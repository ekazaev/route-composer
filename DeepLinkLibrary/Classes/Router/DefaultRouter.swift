//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

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

        // Build stack of factories and find view controller to start presentation process from.
        guard let stack = prepareFactoriesStack(destination: destination) else {
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

            self.startDeepLinking(viewController: viewController, factories: factoriesStack, completion: completion)
        }

        return .handled
    }

    private func startDeepLinking(viewController: UIViewController, factories: [Factory], completion: (() -> Void)?) {

        // If we found a view controller to start from - lets close all the presented view controllers above to be able
        // to build new stack in needed.
        // We already checked that they can be dissmissed.
        viewController.dismissAllPresentedControllers(animated: true) {
            self.runViewControllerBuildStack(rootViewController: viewController, factories: factories) { viewController in
                self.makeContainersActive(toShow: viewController)
                completion?()
            }
        }
    }

    private func prepareFactoriesStack<A: DeepLinkDestination>(destination: A) -> (rootViewController: UIViewController, factories: [Factory], interceptors: [RouterInterceptor])? {
        var step: Step? = destination.screen.step

        var rootViewController: UIViewController?

        var tempFactories: [Factory] = []

        var allFactories: [Factory] = []

        var interceptors: [RouterInterceptor] = []

        // Build stack until we have steps and view controller to present from has not been found
        buildCycle: repeat {

            // Trying to find a view controller to start building stack from
            guard let result = step?.getPresentationViewController(with: destination.arguments) else {
                return nil
            }

            switch result {
            case .found(let viewController):
                // If found we should finish cycle and start building factories if necessary.
                rootViewController = viewController
                break buildCycle
            case .continueRouting:
                break
            case .failure:
                return nil
            }

            // If step contain an action that needs to be done, add it it in to interceptors array
            if let interceptor = step?.interceptor {
                interceptors.append(interceptor)
            }

            // If view controller has not been found, but screen has a factroy to build itself - add factory to the stack
            if let factory = step?.factory {
                allFactories.insert(factory, at: 0)

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
                        allFactories = allFactories.filter { screen in
                            !merged.contains { factory in
                                factory === screen
                            }
                        }

                    }
                    tempFactories = []
                }
                tempFactories.insert(factory, at: 0)
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
            return (rootViewController: viewController, factories: allFactories, interceptors: interceptors)
        }

        return nil
    }

    // This function loops through the list of factories and build them in sequence.
    // Because some actions can be asynchronous, like push, modal or presentations,
    // it does it builds asynchronously
    private func runViewControllerBuildStack(rootViewController: UIViewController, factories: [Factory], completion: @escaping ((_: UIViewController) -> Void)) {
        var factories = factories

        func buildScreens(_ screen: Factory, _ previousViewController: UIViewController) {
            if let newViewController = screen.build() {
                // If factory contains action - applying it
                if let action = screen.action {
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
