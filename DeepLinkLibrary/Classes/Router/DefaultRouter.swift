//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

private struct PostTaskSlip {
    // This reference is weak because even though this view controller was created by a fabric but then some other
    // view controller in the chain can have an action that will actually remove this view controller from the stack.
    // we do not want to keep a strong reference to it and prevent it from deallocation. Potentially it's a very rare
    // issue but must be kept in mind.
    weak var viewController: UIViewController?

    let postTask: PostRoutingTask
}

/// Each post action needs to know a view controller is should be applied to.
/// This decorator adds functionality of storing UIViewControllers created by the factory and frees custom factories
/// implementations from dealing with it. Mostly it is important for ContainerFactories which create merged view
/// controllers without Router's help.
private class FactoryDecorator: AnyFactory {

    var action: Action {
        get {
            return factory.action
        }
    }

    let factory: AnyFactory

    weak var postTaskRunner: PostTaskRunner?

    var postTask: PostRoutingTask?

    init(factory: AnyFactory, postTask: PostRoutingTask?, postTaskRunner: PostTaskRunner) {
        self.factory = factory
        self.postTaskRunner = postTaskRunner
        self.postTask = postTask
    }

    func prepare(with arguments: Any?) -> RoutingResult {
        return factory.prepare(with: arguments)
    }

    func build(with logger: Logger?) -> UIViewController? {
        guard let viewController = factory.build(with: logger) else {
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

    func run<A: RoutingDestination>(for destination: A) {
        let viewControllers = taskSlips.flatMap({ $0.viewController })
        taskSlips.forEach({ slip in
            guard let viewController = slip.viewController else {
                return
            }
            slip.postTask.execute(on: viewController, with: destination.arguments, routingStack: viewControllers)
        })
    }
}

public class DefaultRouter: Router {

    public let logger: Logger?

    public init(logger: Logger? = nil) {
        self.logger = logger
    }

    @discardableResult
    public func deepLinkTo<A: RoutingDestination>(destination: A, animated: Bool = true, completion: ((_: Bool) -> Void)? = nil) -> RoutingResult {

        // If currently visible view controller can not be dismissed then we can't deeplink anywhere, because it will
        // disappear as a result of deeplinking.
        if let topMostViewController = UIWindow.key?.topmostViewController as? RouterRulesViewController, !topMostViewController.canBeDismissed {
            logger?.log(.warning("Topmost view controller can not be dismissed."))
            return .unhandled
        }

        let postTaskRunner = PostTaskRunner()
        // Build stack of factories and find a view controller to start a presentation process from.
        // Returns (rootViewController, factories, interceptor) tuple
        // where rootViewController is the origin of the chain of views to be built for a given destination.
        guard let stack = prepareStack(destination: destination, postTaskRunner: postTaskRunner) else {
            return .unhandled
        }

        let viewController = stack.rootViewController,
                factoriesStack = stack.factories,
                interceptor = stack.interceptor

        // check if the view controllers, that are currently presented from the origin view controller for a given destination, can be dismissed.
        if let viewController = UIViewController.findAllPresentedViewControllers(starting: viewController).flatMap({
            $0 as? RouterRulesViewController
        }).first(where: {
            !$0.canBeDismissed
        }) {
            logger?.log(.warning("\(viewController) view controller can not be dismissed."))
            return .unhandled
        }

        // Execute interceptors associated to the each view in the chain. All of interceptors must succeed to continue routing.
        interceptor.execute(with: destination.arguments, logger: logger) { [weak viewController] result in
            guard result == .success else {
                completion?(false)
                return
            }

            guard let viewController = viewController else {
                self.logger?.log(.error("View controller that been chosen as a starting point of rooting been " +
                        "destroyed while router was waiting for interceptor's result."))
                completion?(false)
                return
            }

            self.startDeepLinking(viewController: viewController, animated: animated, factories: factoriesStack) { viewController in
                self.makeContainersActive(toShow: viewController, animated: animated)
                postTaskRunner.run(for: destination)
                completion?(true)
            }
        }

        return .handled
    }

    private func prepareStack<A: RoutingDestination>(destination: A, postTaskRunner: PostTaskRunner) -> (rootViewController: UIViewController, factories: [AnyFactory], interceptor: RouterInterceptor)? {

        var step: RoutingStep? = destination.finalStep

        var rootViewController: UIViewController?

        var tempFactories: [AnyFactory] = []

        var factories: [AnyFactory] = []

        var interceptors: [RouterInterceptor] = []

        // Build stack until we have steps and the view controller to present from has not been found
        repeat {

            // Trying to find a view controller to start building the stack from
            guard let result = step?.perform(with: destination.arguments) else {
                return nil
            }

            // If step contain an action that needs to be done, add it in the interceptors array
            if let interceptor = step?.interceptor, rootViewController == nil {
                interceptors.append(interceptor)
            }

            switch result {
            case .success(let viewController):
                if rootViewController == nil {
                    rootViewController = viewController
                    logger?.log(.info("Step \(step!) has found a \(viewController) to start presentation from."))
                }
                if let postTask = step?.postTask {
                    postTaskRunner.taskSlips.insert(PostTaskSlip(viewController: viewController, postTask: postTask), at: 0)
                }
                break
            case .continueRouting(let factory):
                logger?.log(.info("Step \(step!) has not found its view controller is stack, so router will continue search."))

                // If view controller has not been found, but step has a factory to build itself - add factory to the stack
                if rootViewController == nil, let factory = factory {
                    let factoryDecorator = FactoryDecorator(factory: factory, postTask: step?.postTask, postTaskRunner: postTaskRunner)
                    factories.insert(factoryDecorator, at: 0)

                    // If some factory can not prepare itself (e.g. does not have enough data in arguments) then deep link stack
                    // can not be built
                    if factory.prepare(with: destination.arguments) == .unhandled {
                        logger?.log(.error("Factory \(factory) could not prepare itself to be ready to build a View Controller."))
                        return nil
                    }

                    // If current factory actually creates Container then it should know how to deal with the factories that
                    // should be in this container, based on an action attached to the factory.
                    // For example navigationController factory should use factories to build navigation controller stack.
                    if let factory = factory as? AnyContainerFactory, let container = factory.hasContainer() {
                        if tempFactories.count > 0 {
                            let rest = container.merge(tempFactories)
                            let merged = tempFactories.filter { factory in
                                !rest.contains { restFactory in
                                    factory === restFactory
                                }
                            }
                            factories = factories.filter { factory in
                                !merged.contains { mergedFactory in
                                    mergedFactory === factory
                                }
                            }

                        }
                        tempFactories = []
                    }
                    tempFactories.insert(factoryDecorator, at: 0)
                }
                break
            case .failure:
                logger?.log(.error("Step has return an error while looking for a view controller to present from."))
                return nil
            }

            step = step?.previousStep
        } while step != nil

        //If we haven't found a View Controller to build the stack from - it means that we can handle deeplinking
        if let viewController = rootViewController {
            return (rootViewController: viewController, factories: factories, interceptor: interceptors.count == 1 ? interceptors.removeFirst() : InterceptorMultiplexer(interceptors))
        }

        return nil
    }

    private func startDeepLinking(viewController: UIViewController, animated: Bool, factories: [AnyFactory], completion: @escaping ((_: UIViewController) -> Void)) {
        // If we found a view controller to start from - lets close all the presented view controllers above to be able
        // to build a new stack if needed.
        // We already checked that they can be dismissed.
        viewController.dismissAllPresentedControllers(animated: animated) {
            self.runViewControllerBuildStack(rootViewController: viewController, factories: factories, animated: animated) { viewController in
                completion(viewController)
            }
        }
    }

    // This function loops through the list of factories and build views in sequence.
    // Because some actions can be asynchronous, like push, modal or presentations,
    // it builds asynchronously
    private func runViewControllerBuildStack(rootViewController: UIViewController, factories: [AnyFactory], animated: Bool, completion: @escaping ((_: UIViewController) -> Void)) {
        var factories = factories

        func buildViewController(_ factory: AnyFactory, _ previousViewController: UIViewController) {
            // If view controller found but view is not loaded or has no window that it belongs, it means that it was just cached by container view controller
            // like in UITabBarController it happens with a view controller in a tab that was never activated before,
            // So we have to make it active first.
            // Example: TabBar contains navigation controller in the tab that was never opened and we are going to push in to
            // it, UINavigationController in this case will not update it content properly. Possible to reproduce in clean project
            // without DeepLinkLibrary.
            if !previousViewController.isViewLoaded || previousViewController.view.window == nil {
                makeContainersActive(toShow: previousViewController, animated: false)
            }

            var factoryToLog = factory
            if let factory = factory as? FactoryDecorator {
                factoryToLog = factory.factory
            }
            if let newViewController = factory.build(with: logger) {
                logger?.log(.info("Factory \(factoryToLog) has built a \(newViewController) to start presentation from."))
                factory.action.perform(viewController: newViewController, on: previousViewController, animated: animated, logger: self.logger) { result in
                    guard result == .continueRouting else {
                        self.logger?.log(.error("Action \(factory.action) has stopped routing as it was not able to build a view controller in to a stack."))
                        completion(newViewController)
                        return
                    }
                    guard factories.count > 0 else {
                        completion(newViewController)
                        return
                    }
                    buildViewController(factories.removeFirst(), newViewController)
                }
            } else {
                logger?.log(.warning("Factory \(factoryToLog) has not built any view controller."))
                completion(previousViewController)
            }
        }

        guard factories.count > 0 else {
            completion(rootViewController)
            return
        }
        buildViewController(factories.removeFirst(), rootViewController)
    }

    // this function activates the origin view controller of viewController
    private func makeContainersActive(toShow viewController: UIViewController, animated: Bool) {
        var iterationViewController = viewController
        while let parent = iterationViewController.parent {
            if let container = parent as? ContainerViewController {
                container.makeVisible(viewController: iterationViewController, animated: animated)
            }
            iterationViewController = parent
        }
    }

}
