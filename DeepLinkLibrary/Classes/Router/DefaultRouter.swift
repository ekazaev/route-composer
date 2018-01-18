//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

private struct PostTaskSlip {
    let viewController: UIViewController
    let postTask: PostRoutingTask
}

private class FactoryDecorator: Factory {
    var action: ViewControllerAction? {
        get {
            return factory.action
        }
    }

    let factory: Factory

    weak var postTaskRunner: PostTaskRunner?

    var postTask: PostRoutingTask?

    init(factory: Factory, postTask: PostRoutingTask?, postTaskRunner: PostTaskRunner) {
        self.factory = factory
        self.postTaskRunner = postTaskRunner
        self.postTask = postTask
    }

    func build() -> UIViewController? {
        guard let viewController = factory.build() else {
            return nil
        }
        if let postTask = postTask {
            postTaskRunner?.taskSlips.append(PostTaskSlip(viewController: viewController, postTask: postTask))
        }
        return viewController
    }
}

private class PostTaskRunner {

    var taskSlips: [PostTaskSlip] = []

    func run<A: DeepLinkDestination>(for destinaion: A) {
        taskSlips.forEach({ $0.postTask.execute(on: $0.viewController, with: destinaion.arguments) })
    }
}

public class DefaultRouter: Router {

    public init() {

    }

    @discardableResult
    public func deepLinkTo<A: DeepLinkDestination>(destination: A, completion: (() -> Void)? = nil) -> DeepLinkResult {

        // If currently visible view controller can not be dissmissed - then we cant deeplink anywhere because it will
        // disappear as a result of deeplinking.
        if let topMostViewControler = UIWindow.key?.topmostViewController as? RouterRulesViewController, !topMostViewControler.canBeDismissed {
            return .unhandled
        }

        let postTaskRunner = PostTaskRunner()
        // Build stack of factories and find view controller to start presentation process from.
        guard let stack = prepareStack(destination: destination, postTaskRunner: postTaskRunner) else {
            return .unhandled
        }

        let viewController = stack.rootViewController, factoriesStack = stack.factories, interceptor = InterceptorMultiplex(stack.interceptors)

        // Let find is we are eligible to dismiss view controllers in stack to show target view controller
        if let _ = UIViewController.findAllPresentedViewControllers(starting: viewController).flatMap({
            $0 as? RouterRulesViewController
        }).first(where: {
            !$0.canBeDismissed
        }) {
            return .unhandled
        }

        // Lets run the interceptor chain. All of interceptor must succeed to continue routing.
        interceptor.apply(with: destination.arguments) { result in
            guard result == .success else {
                completion?()
                return
            }

            self.startDeepLinking(viewController: viewController, factories: factoriesStack) { viewController in
                self.makeContainersActive(toShow: viewController)
                postTaskRunner.run(for: destination)
                completion?()
            }
        }

        return .handled
    }

    private func prepareStack<A: DeepLinkDestination>(destination: A, postTaskRunner: PostTaskRunner) -> (rootViewController: UIViewController, factories: [Factory], interceptors: [RouterInterceptor])? {
        var step: Step? = destination.screen.step

        var rootViewController: UIViewController?

        var tempFactories: [Factory] = []

        var factories: [Factory] = []

        var interceptors: [RouterInterceptor] = []

        // Build stack until we have steps and view controller to present from has not been found
        repeat {

            // Trying to find a view controller to start building stack from
            guard let result = step?.getPresentationViewController(with: destination.arguments) else {
                return nil
            }

            switch result {
            case .found(let viewController):
                if rootViewController == nil {
                    rootViewController = viewController
                }
                if let postTask = step?.postTask {
                    postTaskRunner.taskSlips.append(PostTaskSlip(viewController: viewController, postTask: postTask))
                }
                break
            case .continueRouting:
                break
            case .failure:
                return nil
            }

            // If step contain an action that needs to be done, add it it in to interceptors array
            if let interceptor = step?.interceptor, rootViewController == nil {
                interceptors.append(interceptor)
            }

            //Building factory stack only if we havent find a view controllers to start from
            if rootViewController == nil {
                // If view controller has not been found, but screen has a factroy to build itself - add factory to the stack
                if let factory = step?.factory {
                    let factoryDecorator = FactoryDecorator(factory: factory, postTask: step?.postTask, postTaskRunner: postTaskRunner)
                    factories.insert(factoryDecorator, at: 0)

                    // If some factory can not prepare itself (eg doe not have enough data in arguments) then deep link stack
                    // can not be build
                    if let preparableFactory = factory as? PreparableFactory,
                       preparableFactory.prepare(with: destination.arguments) == .unhandled {
                        return nil
                    }

                    // If current factory actually creates Contanier then it should now how to deal with factories that
                    // should be in this container, based on an action attached to the factory.
                    // For example navigationController factory should use factories to build navigation controller stack.
                    if let container = factory as? ContainerFactory {
                        if tempFactories.count > 0 {
                            let rest = container.merge(tempFactories)
                            let merged = tempFactories.filter { screen in
                                !rest.contains { factory in
                                    screen === factory
                                }
                            }
                            factories = factories.filter { screen in
                                !merged.contains { factory in
                                    factory === screen
                                }
                            }

                        }
                        tempFactories = []
                    }
                    tempFactories.insert(factoryDecorator, at: 0)
                }
            }

            step = step?.prevStep
        } while step != nil

        //If we haven't find a View Controller to start build stack from - it means that we can handle a deeplinking
        if let viewController = rootViewController {
            // If view controller found but view is not loaded it means that it was just cached by container view controller
            // like in UITabBarController it happens with a view controller in a tab that was never activated before,
            // So we have to make it active first.
            if !viewController.isViewLoaded {
                makeContainersActive(toShow: viewController)
            }
            return (rootViewController: viewController, factories: factories, interceptors: interceptors)
        }

        return nil
    }

    private func startDeepLinking(viewController: UIViewController, factories: [Factory], completion: @escaping ((_: UIViewController) -> Void)) {
        // If we found a view controller to start from - lets close all the presented view controllers above to be able
        // to build new stack in needed.
        // We already checked that they can be dissmissed.
        viewController.dismissAllPresentedControllers(animated: true) {
            self.runViewControllerBuildStack(rootViewController: viewController, factories: factories) { viewController in
                completion(viewController)
            }
        }
    }

    // This function loops through the list of factories and build them in sequence.
    // Because some actions can be asynchronous, like push, modal or presentations,
    // it does it builds asynchronously
    private func runViewControllerBuildStack(rootViewController: UIViewController, factories: [Factory], completion: @escaping ((_: UIViewController) -> Void)) {
        var factories = factories

        func buildScreens(_ factory: Factory, _ previousViewController: UIViewController) {
            if let newViewController = factory.build() {
                // If factory contains action - applying it
                if let action = factory.action {
                    action.apply(viewController: newViewController, on: previousViewController) { viewController in
                        guard factories.count > 0 else {
                            completion(viewController)
                            return
                        }
                        buildScreens(factories.removeFirst(), viewController)
                    }
                } else {
                    guard factories.count > 0 else {
                        completion(newViewController)
                        return
                    }
                    buildScreens(factories.removeFirst(), newViewController)
                }
            } else {
                completion(previousViewController)
            }
        }

        guard factories.count > 0 else {
            completion(rootViewController)
            return
        }
        buildScreens(factories.removeFirst(), rootViewController)
    }

    //This block fuction that all the container view controllers switched to show correctly build view controller
    private func makeContainersActive(toShow viewController: UIViewController) {
        if let container = UIWindow.key?.topmostViewController as? ContainerViewController {
            container.makeActive(vc: viewController)
        }
    }

}
