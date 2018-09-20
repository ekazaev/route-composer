//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import UIKit

/// Default `Router` implementation
public struct DefaultRouter: Router, InterceptableRouter {

    /// A `Logger` instance to be used by the `DefaultRouter`.
    public let logger: Logger?

    private var interceptors: [AnyRoutingInterceptor] = []

    private var contextTasks: [AnyContextTask] = []

    private var postTasks: [AnyPostRoutingTask] = []

    /// Constructor
    ///
    /// - Parameter logger: A `Logger` instance to be used by the `DefaultRouter`.
    public init(logger: Logger? = nil) {
        self.logger = logger
    }

    @discardableResult
    public mutating func add<R: RoutingInterceptor>(_ interceptor: R) -> DefaultRouter where R.Context == Any? {
        self.interceptors.append(RoutingInterceptorBox(interceptor))
        return self
    }

    @discardableResult
    public mutating func add<CT: ContextTask>(_ contextTask: CT) -> DefaultRouter where CT.Context == Any? {
        self.contextTasks.append(ContextTaskBox(contextTask))
        return self
    }

    @discardableResult
    public mutating func add<P: PostRoutingTask>(_ postTask: P) -> DefaultRouter where P.Context == Any? {
        self.postTasks.append(PostRoutingTaskBox(postTask))
        return self
    }

    @discardableResult
    public func navigate<ViewController: UIViewController, Context>(to step: DestinationStep<ViewController, Context>,
                                                                    with context: Context,
                                                                    animated: Bool = true,
                                                                    completion: ((_: RoutingResult) -> Void)? = nil) -> RoutingResult {

        guard Thread.isMainThread else {
            logger?.log(.error("Attempt to call UI API not on the main thread."))
            return .unhandled
        }

        // If currently visible view controller can not be dismissed then we can't route anywhere, because it will
        // disappear as a result of routing.
        if let topMostViewController = UIWindow.key?.topmostViewController as? RoutingInterceptable,
           !topMostViewController.canBeDismissed {
            logger?.log(.warning("Topmost view controller can not be dismissed."))
            return .unhandled
        }

        let postTaskRunner = PostTaskRunner()
        // Build stack of factories and find a view controller to start a presentation process from.
        // Returns (rootViewController, factories, interceptor) tuple
        // where rootViewController is the origin of the chain of views to be built for a given destination.
        guard let stack = prepareStack(to: step, with: context, postTaskRunner: postTaskRunner) else {
            return .unhandled
        }

        let viewController = stack.rootViewController, factoriesStack = stack.factories, interceptor = stack.interceptor

        // check if the view controllers, that are currently presented from the origin view controller for a
        // given destination, can be dismissed.
        if let viewController = Array([[viewController], viewController.allPresentedViewControllers].joined()).nonDismissibleViewController {
            logger?.log(.warning("\(String(describing: viewController)) view controller can not be dismissed."))
            return .unhandled
        }

        // Execute interceptors associated to the each view in the chain. All of interceptors must succeed to
        // continue routing.
        interceptor.execute(with: context) { [weak viewController] result in
            func failGracefully(_ message: LoggerMessage) {
                self.logger?.log(message)
                completion?(.unhandled)
            }

            guard Thread.isMainThread else {
                return failGracefully(.error("Attempt to call UI API not on the main thread."))
            }

            if case let .failure(message) = result {
                return failGracefully(.warning(message ?? "\(interceptor) interceptor stopped routing."))
            }

            guard let viewController = viewController else {
                return failGracefully(.warning("View controller that been chosen as a starting point of rooting been " +
                        "destroyed while router was waiting for interceptor's result."))
            }

            // If we found a view controller to start from - lets close all the presented view controllers above to be able
            // to build a new stack if needed.
            // We already checked that they can be dismissed.
            self.dismissPresentedIfNeeded(from: viewController, animated: animated) {
                self.runViewControllerBuildStack(starting: viewController,
                        with: context,
                        using: factoriesStack,
                        animated: animated) { viewController, result in
                    // Even if the result is unhandled - we still have to run all the tasks
                    self.makeContainersActive(toShow: viewController, animated: animated)
                    self.doTry({
                        try postTaskRunner.run(for: context)
                    }, finally: { success in
                        completion?(success ? result : .unhandled)
                    })
                }
            }
        }

        return .handled
    }

    private func prepareStack(to finalStep: RoutingStep, with context: Any?, postTaskRunner: PostTaskRunner) -> (rootViewController: UIViewController,
                                                                                                                 factories: [AnyFactory],
                                                                                                                 interceptor: AnyRoutingInterceptor)? {

        func mergeGlobalTasks(step: InterceptableStep?) -> (contextTasks: [AnyContextTask], postTasks: [AnyPostRoutingTask]) {
            var contextTasks = self.contextTasks
            var postTasks = self.postTasks
            if let contextTask = step?.contextTask {
                contextTasks.append(contextTask)
            }
            if let postTask = step?.postTask {
                postTasks.append(postTask)
            }
            if postTasks.isEmpty {
                postTasks.append(PostRoutingTaskBox(EmptyPostTask()))
            }
            return (contextTasks: contextTasks, postTasks: postTasks)
        }

        var rootViewController: UIViewController?

        var factories: [AnyFactory] = []

        var interceptors: [AnyRoutingInterceptor] = []

        doTry({
            //Adding default preset interceptors
            interceptors = try self.interceptors.map({
                var globalInterceptor = $0
                try globalInterceptor.prepare(with: context)
                return globalInterceptor
            })
            var currentStep: RoutingStep? = finalStep

            // Build stack until we have steps and the view controller to present from is not found
            repeat {
                let interceptableStep = currentStep as? InterceptableStep

                // If step contain an `Action` that needs to be done, add it in the interceptors array
                if var interceptor = interceptableStep?.interceptor {
                    try interceptor.prepare(with: context)
                    interceptors.append(interceptor)
                }

                if let performableStep = currentStep as? PerformableStep {

                    // Trying to find a view controller to start building the stack from
                    switch performableStep.perform(for: context) {
                    case .success(let viewController):
                        if rootViewController == nil {
                            rootViewController = viewController
                            logger?.log(.info("\(String(describing: currentStep!)) found a " +
                                    "\(String(describing: viewController)) to start presentation from."))
                        }

                        let taskMergeResult = mergeGlobalTasks(step: interceptableStep)
                        try taskMergeResult.contextTasks.forEach({
                            var contextTask = $0
                            try contextTask.prepare(with: context)
                            try contextTask.apply(on: viewController, with: context)
                        })

                        postTaskRunner.add(postTasks: taskMergeResult.postTasks, to: viewController)
                    case .continueRouting(let factory):
                        // If view controller is not found, but step has a `Factory` to build itself -
                        // add factory to the stack
                        if rootViewController == nil {
                            logger?.log(.info("\(String(describing: currentStep!)) not found its view " +
                                    "controller is stack, so router will continue search."))
                            if var factory = factory {
                                // If step contains post task, them lets create a `Factory` decorator that will
                                // handle view controller and post task chain after view controller creation.
                                if let internalStep = interceptableStep {
                                    var taskMergeResult = mergeGlobalTasks(step: internalStep)
                                    taskMergeResult.contextTasks = try taskMergeResult.contextTasks.map({
                                        var contextTask = $0
                                        try contextTask.prepare(with: context)
                                        return contextTask
                                    })

                                    factory = FactoryDecorator(factory: factory,
                                            contextTasks: taskMergeResult.contextTasks,
                                            postTasks: taskMergeResult.postTasks,
                                            postTaskRunner: postTaskRunner)
                                }

                                // If some `Factory` can not prepare itself (e.g. does not have enough data in context)
                                // then view controllers stack
                                // can not be built
                                try factory.prepare(with: context)

                                // If current factory creates a Container then it should know how to deal with
                                // the factories that
                                // should be in this container, based on an action attached to the factory.
                                // For example navigationController factory should use factories to build navigation
                                // controller stack.
                                factories = try factory.scrapeChildren(from: factories)
                                factories.insert(factory, at: 0)
                            }
                        }
                    case .failure:
                        throw RoutingError.message("\(String(describing: currentStep)) failed while it was " +
                                "looking for a view controller to present from.")
                    }
                }

                guard let chainingStep = currentStep as? ChainableStep,
                      let previousStep = chainingStep.previousStep else {
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

        //If we haven't found a View Controller to build the stack from - it means that we can't handle routing.
        if let viewController = rootViewController {
            return (rootViewController: viewController,
                    factories: factories,
                    interceptor: interceptors.count == 1 ? interceptors.removeFirst() : InterceptorMultiplexer(interceptors))
        }

        return nil
    }

    // This function loops through the list of factories and build views in sequence.
    // Because some actions can be asynchronous, like push, modal or presentations,
    // it builds asynchronously
    private func runViewControllerBuildStack(starting rootViewController: UIViewController,
                                             with context: Any?,
                                             using factories: [AnyFactory],
                                             animated: Bool,
                                             completion: @escaping ((_: UIViewController, _: RoutingResult) -> Void)) {
        var factories = factories

        func buildViewController(from previousViewController: UIViewController) {
            guard !factories.isEmpty else {
                completion(previousViewController, .handled)
                return
            }
            let factory = factories.removeFirst()
            // If view controller found but view is not loaded or has no window that it belongs, it means that it
            // was just cached by container view controller like in UITabBarController it happens with a view
            // controller in a tab that was never activated before,
            // So we have to make it active first.
            // Example: TabBar contains navigation controller in the tab that was never opened and we are going
            // to push in to it, UINavigationController in this case will not update it content properly.
            // Possible to reproduce in clean project without RouteComposer.
            if !previousViewController.isViewLoaded || previousViewController.view.window == nil {
                makeContainersActive(toShow: previousViewController, animated: false)
            }

            doTry({
                let newViewController = try factory.build(with: context)
                logger?.log(.info("Factory \(String(describing: factory)) built a " +
                        "\(String(describing: newViewController))."))
                factory.action.perform(with: newViewController, on: previousViewController, animated: animated) { result in
                    if case let .failure(message) = result {
                        self.logger?.log(.error(message ?? "Action \(String(describing: factory.action)) stopped " +
                                "routing as it was not able to build a view controller in to a stack."))
                        completion(newViewController, .unhandled)
                        return
                    }
                    self.logger?.log(.info("Action \(String(describing: factory.action)) applied to a " +
                            "\(String(describing: previousViewController)) with " +
                            "\(String(describing: newViewController))."))
                    buildViewController(from: newViewController)
                }
            }, finally: { success in
                if !success {
                    completion(previousViewController, .unhandled)
                }
            })
        }

        buildViewController(from: rootViewController)
    }

    // this function activates the origin view controller of viewController
    private func makeContainersActive(toShow viewController: UIViewController, animated: Bool) {
        var iterationViewController = viewController
        while let parentViewController = iterationViewController.parent {
            if let container = parentViewController as? ContainerViewController {
                container.makeVisible(iterationViewController, animated: animated)
            }
            iterationViewController = parentViewController
        }
    }

    private func dismissPresentedIfNeeded(from viewController: UIViewController, animated: Bool, completion: @escaping (() -> Void)) {
        if viewController.presentedViewController != nil {
            viewController.dismiss(animated: animated) {
                completion()
            }
        } else {
            completion()
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
            logger?.log(.error("An error occurred during the navigation process. Underlying error: \(error)"))
            finallyBlock?(false)
        }
    }

}
