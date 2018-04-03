//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

/// Deep Linking Library routing implementations
public class DefaultRouter: Router {

    /// Logger instance
    public let logger: Logger?

    public init(logger: Logger? = nil) {
        self.logger = logger
    }

    @discardableResult
    public func deepLinkTo<D: RoutingDestination>(destination: D, animated: Bool = true, completion: ((_: Bool) -> Void)? = nil) -> RoutingResult {
        logger?.routingWillStart()
        // If currently visible view controller can not be dismissed then we can't deeplink anywhere, because it will
        // disappear as a result of deeplinking.
        if let topMostViewController = UIWindow.key?.topmostViewController as? RoutingInterceptable, !topMostViewController.canBeDismissed {
            logger?.log(.warning("Topmost view controller can not be dismissed."))
            logger?.routingDidFinish()
            return .unhandled
        }

        let postTaskRunner = PostTaskRunner<D>()
        // Build stack of factories and find a view controller to start a presentation process from.
        // Returns (rootViewController, factories, interceptor) tuple
        // where rootViewController is the origin of the chain of views to be built for a given destination.
        guard let stack = prepareStack(destination: destination, postTaskRunner: postTaskRunner) else {
            logger?.routingDidFinish()
            return .unhandled
        }

        let viewController = stack.rootViewController,
                factoriesStack = stack.factories,
                interceptor = stack.interceptor

        // check if the view controllers, that are currently presented from the origin view controller for a given destination, can be dismissed.
        if let viewController = viewController.allPresentedViewControllers.nonDismissibleViewController {
            logger?.log(.warning("\(String(describing: viewController)) view controller can not be dismissed."))
            logger?.routingDidFinish()
            return .unhandled
        }

        // Execute interceptors associated to the each view in the chain. All of interceptors must succeed to continue routing.
        interceptor.execute(for: destination) { [weak viewController] result in
            if case let .failure(message) = result {
                self.logger?.log(.warning(message ?? "\(interceptor) interceptor stopped routing."))
                completion?(false)
                self.logger?.routingDidFinish()
                return
            }

            guard let viewController = viewController else {
                self.logger?.log(.warning("View controller that been chosen as a starting point of rooting been " +
                        "destroyed while router was waiting for interceptor's result."))
                completion?(false)
                self.logger?.routingDidFinish()
                return
            }

            self.startDeepLinking(viewController: viewController, context: destination.context, animated: animated, factories: factoriesStack) { viewController in
                self.makeContainersActive(toShow: viewController, animated: animated)
                self.doTry({
                    try postTaskRunner.run(for: destination)
                }, finally: { success in
                    completion?(success)
                })
                self.logger?.routingDidFinish()
            }
        }

        return .handled
    }

    private func prepareStack<D>(destination: D, postTaskRunner: PostTaskRunner<D>) -> (rootViewController: UIViewController, factories: [AnyFactory], interceptor: AnyRoutingInterceptor)? {
        var rootViewController: UIViewController?

        var factories: [AnyFactory] = []

        var interceptors: [AnyRoutingInterceptor] = []

        doTry({

            var currentStep: RoutingStep? = destination.finalStep

            // Build stack until we have steps and the view controller to present from is not found
            repeat {
                let interceptableStep = currentStep as? InterceptableStep

                // If step contain an action that needs to be done, add it in the interceptors array
                if let interceptor = interceptableStep?.interceptor {
                    interceptors.append(interceptor)
                }

                if let performableStep = currentStep as? PerformableStep {

                    // Trying to find a view controller to start building the stack from
                    switch performableStep.perform(for: destination) {
                    case .success(let viewController):
                        if rootViewController == nil {
                            rootViewController = viewController
                            logger?.log(.info("Step \(String(describing: currentStep!)) found a \(String(describing: viewController)) to start presentation from."))
                        }
                        if let contextTask = interceptableStep?.contextTask {
                            try contextTask.prepare(with: destination.context, for: destination)
                            contextTask.apply(on: viewController, with: destination.context, for: destination)
                        }
                        if let postTask = interceptableStep?.postTask {
                            postTaskRunner.taskSlips.insert(PostTaskSlip(viewController: viewController, postTask: postTask), at: 0)
                        }
                        break
                    case .continueRouting(let factory):
                        // If view controller is not found, but step has a factory to build itself - add factory to the stack
                        if rootViewController == nil {
                            logger?.log(.info("Step \(String(describing: currentStep!)) not found its view controller is stack, so router will continue search."))
                            if var factory = factory {
                                // If step contains post task, them lets create a factory decorator that will handle view
                                // controller and post task chain after view controller creation.
                                if let internalStep = interceptableStep {
                                    try internalStep.contextTask?.prepare(with: destination.context, for: destination)
                                    factory = FactoryDecorator(factory: factory, contextTask: internalStep.contextTask, postTask: internalStep.postTask, postTaskRunner: postTaskRunner, logger: logger, destination: destination)
                                }
                                // If some factory can not prepare itself (e.g. does not have enough data in context) then deep link stack
                                // can not be built
                                try factory.prepare(with: destination.context)

                                // If current factory actually creates Container then it should know how to deal with the factories that
                                // should be in this container, based on an action attached to the factory.
                                // For example navigationController factory should use factories to build navigation controller stack.
                                factories = factory.scrapeChildren(from: factories)
                                factories.insert(factory, at: 0)
                            }
                        }
                        break
                    case .failure:
                        throw RoutingError.message("Step \(String(describing: currentStep)) failed while it was looking for a view controller to present from.")
                    }
                }

                guard let chainingStep = currentStep as? ChainableStep,
                      let previousStep = chainingStep.previousStep as? RoutingStep & PerformableStep else {
                    break
                }
                currentStep = previousStep
            } while currentStep != nil

        }, finally: { success in
            if !success {
                rootViewController = nil
                factories = []
                interceptors = []
            }
        })

        //If we haven't found a View Controller to build the stack from - it means that we can handle deeplinking
        if let viewController = rootViewController {
            return (rootViewController: viewController, factories: factories, interceptor: interceptors.count == 1 ? interceptors.removeFirst() : InterceptorMultiplexer(interceptors))
        }

        return nil
    }

    private func startDeepLinking(viewController: UIViewController, context: Any?, animated: Bool, factories: [AnyFactory], completion: @escaping ((_: UIViewController) -> Void)) {
        // If we found a view controller to start from - lets close all the presented view controllers above to be able
        // to build a new stack if needed.
        // We already checked that they can be dismissed.
        viewController.dismissAllPresentedControllers(animated: animated) {
            self.runViewControllerBuildStack(rootViewController: viewController, context: context, factories: factories, animated: animated) { viewController in
                completion(viewController)
            }
        }
    }

    // This function loops through the list of factories and build views in sequence.
    // Because some actions can be asynchronous, like push, modal or presentations,
    // it builds asynchronously
    private func runViewControllerBuildStack(rootViewController: UIViewController, context: Any?, factories: [AnyFactory], animated: Bool, completion: @escaping ((_: UIViewController) -> Void)) {
        guard factories.count > 0 else {
            completion(rootViewController)
            return
        }
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

            doTry({
                let newViewController = try factory.build(with: context)
                logger?.log(.info("Factory \(String(describing: factory)) built a \(String(describing: newViewController))."))
                factory.action.perform(viewController: newViewController, on: previousViewController, animated: animated) { result in
                    if case let .failure(message) = result {
                        self.logger?.log(.error(message ?? "Action \(String(describing: factory.action)) stopped routing as it was not able to build a view controller in to a stack."))
                        completion(newViewController)
                        return
                    }
                    self.logger?.log(.info("Action \(String(describing: factory.action)) applied to a \(String(describing: previousViewController)) with \(String(describing: newViewController))."))
                    guard factories.count > 0 else {
                        completion(newViewController)
                        return
                    }
                    buildViewController(factories.removeFirst(), newViewController)
                }
            }, finally: { success in
                if !success {
                    completion(previousViewController)
                }
            })
        }

        buildViewController(factories.removeFirst(), rootViewController)
    }

    // this function activates the origin view controller of viewController
    private func makeContainersActive(toShow viewController: UIViewController, animated: Bool) {
        var iterationViewController = viewController
        while let parent = iterationViewController.parent {
            if let container = parent as? ContainerViewController {
                container.makeVisible(iterationViewController, animated: animated)
            }
            iterationViewController = parent
        }
    }

    private struct PostTaskSlip {
        // This reference is weak because even though this view controller was created by a fabric but then some other
        // view controller in the chain can have an action that will actually remove this view controller from the stack.
        // we do not want to keep a strong reference to it and prevent it from deallocation. Potentially it's a very rare
        // issue but must be kept in mind.
        weak var viewController: UIViewController?

        let postTask: AnyPostRoutingTask
    }

    /// Each post action needs to know a view controller is should be applied to.
    /// This decorator adds functionality of storing UIViewControllers created by the factory and frees custom factories
    /// implementations from dealing with it. Mostly it is important for ContainerFactories which create merged view
    /// controllers without `Router`'s help.
    private class FactoryDecorator<D: RoutingDestination>: AnyFactory, CustomStringConvertible {

        var action: Action {
            get {
                return factory.action
            }
        }

        let factory: AnyFactory

        weak var postTaskRunner: PostTaskRunner<D>?

        let contextTask: AnyContextTask?

        let postTask: AnyPostRoutingTask?

        let logger: Logger?

        let destination: D

        init(factory: AnyFactory, contextTask: AnyContextTask?, postTask: AnyPostRoutingTask?, postTaskRunner: PostTaskRunner<D>, logger: Logger?, destination: D) {
            self.factory = factory
            self.postTaskRunner = postTaskRunner
            self.postTask = postTask
            self.contextTask = contextTask
            self.logger = logger
            self.destination = destination
        }

        func prepare(with context: Any?) throws {
            return try factory.prepare(with: context)
        }

        func build(with context: Any?) throws -> UIViewController {
            let viewController = try factory.build(with: context)
            if let context = context, let contextTask = contextTask {
                contextTask.apply(on: viewController, with: context, for: destination)
            }
            if let postTask = postTask {
                postTaskRunner?.taskSlips.append(PostTaskSlip(viewController: viewController, postTask: postTask))
            }
            return viewController
        }

        func scrapeChildren(from factories: [AnyFactory]) -> [AnyFactory] {
            return factory.scrapeChildren(from: factories)
        }

        var description: String {
            return String(describing: factory)
        }

    }

    private func doTry(_ block: (() throws -> Void), finally finallyBlock: ((_: Bool) -> Void)? = nil) {
        do {
            try block()
            finallyBlock?(true)
        } catch RoutingError.message(let message) {
            logger?.log(.error(message))
            finallyBlock?(false)
        } catch {
            logger?.log(.error("An error occurred during routing process. Underlying error: \(error)"))
            finallyBlock?(false)
        }
    }

    private class PostTaskRunner<D: RoutingDestination> {

        var taskSlips: [PostTaskSlip] = []

        func run(for destination: D) throws {
            let viewControllers = taskSlips.compactMap({ $0.viewController })
            try taskSlips.forEach({ slip in
                guard let viewController = slip.viewController else {
                    return
                }
                try slip.postTask.execute(on: viewController, for: destination, routingStack: viewControllers)
            })
        }
    }
}
