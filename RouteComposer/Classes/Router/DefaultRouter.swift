//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import UIKit

/// Deep Linking Library routing implementations
public struct DefaultRouter: Router, AssemblableRouter {
    
    /// `Logger` instance to be used by the `DefaultRouter`.
    public let logger: Logger?

    /// Constructor
    ///
    /// - Parameter logger: `Logger` instance to be used by the `Router`.
    public init(logger: Logger? = nil) {
        self.logger = logger
    }

    private var interceptors: [AnyRoutingInterceptor] = []

    private var contextTasks: [AnyContextTask] = []

    private var postTasks: [AnyPostRoutingTask] = []

    @discardableResult
    public mutating func add<R: RoutingInterceptor>(_ interceptor: R) -> DefaultRouter {
        self.interceptors.append(RoutingInterceptorBox(interceptor))
        return self
    }

    @discardableResult
    public mutating func add<CT: ContextTask>(_ contextTask: CT) -> DefaultRouter {
        self.contextTasks.append(ContextTaskBox(contextTask))
        return self
    }

    @discardableResult
    public mutating func add<P: PostRoutingTask>(_ postTask: P) -> DefaultRouter {
        self.postTasks.append(PostRoutingTaskBox(postTask))
        return self
    }

    /// Routes application to the `RoutingDestination` provided.
    ///
    /// - Parameters:
    ///   - destination: `RoutingDestination` instance.
    ///   - animated: when true - routing should be animated where possible.
    ///   - completion: completion block.
    /// - Returns: `RoutingResult` instance.
    @discardableResult
    public func navigate<D: RoutingDestination>(to destination: D, animated: Bool = true, completion: ((_: RoutingResult) -> Void)? = nil) -> RoutingResult {
        logger?.routingWillStart()

        guard Thread.isMainThread else {
            logger?.log(.error("Attempt to call UI API not on the main thread."))
            logger?.routingDidFinish()
            return .unhandled
        }
        
        // If currently visible view controller can not be dismissed then we can't route anywhere, because it will
        // disappear as a result of routing.
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
            func failGracefully(_ message: LoggerMessage) {
                self.logger?.log(message)
                completion?(.unhandled)
                self.logger?.routingDidFinish()
            }
            
            guard Thread.isMainThread else {
                failGracefully(.error("Attempt to call UI API not on the main thread."))
                return
            }

            if case let .failure(message) = result {
                failGracefully(.warning(message ?? "\(interceptor) interceptor stopped routing."))
                return
            }

            guard let viewController = viewController else {
                failGracefully(.warning("View controller that been chosen as a starting point of rooting been " +
                        "destroyed while router was waiting for interceptor's result."))
                return
            }

            self.startRouting(from: viewController, with: destination.context, building: factoriesStack, animated: animated) { viewController in
                self.makeContainersActive(toShow: viewController, animated: animated)
                self.doTry({
                    try postTaskRunner.run(for: destination)
                }, finally: { success in
                    completion?(success ? .handled : .unhandled)
                })
                self.logger?.routingDidFinish()
            }
        }

        return .handled
    }

    private func prepareStack<D>(destination: D, postTaskRunner: PostTaskRunner<D>) -> (rootViewController: UIViewController, factories: [AnyFactory], interceptor: AnyRoutingInterceptor)? {

        func mergeGlobalTasks(step: InterceptableStep?) -> (contextTasks: [AnyContextTask], postTasks: [AnyPostRoutingTask]){
            var contextTasks = self.contextTasks
            var postTasks = self.postTasks
            if let contextTask = step?.contextTask {
                contextTasks.append(contextTask)
            }
            if let postTask = step?.postTask {
                postTasks.append(postTask)
            }
            if postTasks.count == 0 {
                postTasks.append(PostRoutingTaskBox(EmptyPostTask<D>()))
            }
            return (contextTasks: contextTasks, postTasks: postTasks)
        }

        var rootViewController: UIViewController?

        var factories: [AnyFactory] = []

        var interceptors: [AnyRoutingInterceptor] = []

        var processedViewControllers: [UIViewController] = []

        doTry({

            var currentStep: RoutingStep? = destination.finalStep

            // Build stack until we have steps and the view controller to present from is not found
            repeat {
                let interceptableStep = currentStep as? InterceptableStep

                // If step contain an `Action` that needs to be done, add it in the interceptors array
                if var interceptor = interceptableStep?.interceptor {
                    try interceptor.prepare(with: destination)
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

                        if !processedViewControllers.contains(viewController) {
                            processedViewControllers.append(viewController)

                            let taskMergeResult = mergeGlobalTasks(step: interceptableStep)
                            try taskMergeResult.contextTasks.forEach({
                                var contextTask = $0
                                try contextTask.prepare(with: destination.context, for: destination)
                                try contextTask.apply(on: viewController, with: destination.context, for: destination)
                            })

                            taskMergeResult.postTasks.forEach({
                                postTaskRunner.taskSlips.insert(PostTaskSlip(viewController: viewController, postTask: $0), at: 0)
                            })
                        }
                        break
                    case .continueRouting(let factory):
                        // If view controller is not found, but step has a `Factory` to build itself - add factory to the stack
                        if rootViewController == nil {
                            logger?.log(.info("Step \(String(describing: currentStep!)) not found its view controller is stack, so router will continue search."))
                            if var factory = factory {
                                // If step contains post task, them lets create a `Factory` decorator that will handle view
                                // controller and post task chain after view controller creation.
                                if let internalStep = interceptableStep {
                                    var taskMergeResult = mergeGlobalTasks(step: internalStep)
                                    taskMergeResult.contextTasks = try taskMergeResult.contextTasks.map({
                                        var contextTask = $0
                                        try contextTask.prepare(with: destination.context, for: destination)
                                        return contextTask
                                    })

                                    factory = FactoryDecorator(factory: factory, contextTasks: taskMergeResult.contextTasks, postTasks: taskMergeResult.postTasks, postTaskRunner: postTaskRunner, logger: logger, destination: destination)
                                }

                                // If some `Factory` can not prepare itself (e.g. does not have enough data in context) then view controllers stack
                                // can not be built
                                try factory.prepare(with: destination.context)

                                // If current factory actually creates Container then it should know how to deal with the factories that
                                // should be in this container, based on an action attached to the factory.
                                // For example navigationController factory should use factories to build navigation controller stack.
                                factories = try factory.scrapeChildren(from: factories)
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

        //If we haven't found a View Controller to build the stack from - it means that we can't handle routing.
        if let viewController = rootViewController {
            //Adding default preset interceptors
            interceptors.append(contentsOf: self.interceptors)
            return (rootViewController: viewController, factories: factories, interceptor: interceptors.count == 1 ? interceptors.removeFirst() : InterceptorMultiplexer(interceptors))
        }

        return nil
    }

    private func startRouting(from viewController: UIViewController, with context: Any?, building factories: [AnyFactory], animated: Bool,  completion: @escaping ((_: UIViewController) -> Void)) {
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
            // without RouteComposer.
            if !previousViewController.isViewLoaded || previousViewController.view.window == nil {
                makeContainersActive(toShow: previousViewController, animated: false)
            }

            doTry({
                let newViewController = try factory.build(with: context)
                logger?.log(.info("Factory \(String(describing: factory)) built a \(String(describing: newViewController))."))
                factory.action.perform(with: newViewController, on: previousViewController, animated: animated) { result in
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

    // this class is just a placeholder. Router needs at least one post-routing task per view controller to
    // store a reference there.
    private final class EmptyPostTask<D: RoutingDestination>: PostRoutingTask {

        func execute(on viewController: UIViewController, for destination: D, routingStack: [UIViewController]) {
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
    /// This decorator adds functionality of storing UIViewControllers created by the `Factory` and frees custom factories
    /// implementations from dealing with it. Mostly it is important for ContainerFactories which create merged view
    /// controllers without `Router`'s help.
    private struct FactoryDecorator<D: RoutingDestination>: AnyFactory, CustomStringConvertible {

        var action: Action {
            get {
                return factory.action
            }
        }

        var factory: AnyFactory

        weak var postTaskRunner: PostTaskRunner<D>?

        let contextTasks: [AnyContextTask]

        let postTasks: [AnyPostRoutingTask]

        let logger: Logger?

        let destination: D

        init(factory: AnyFactory, contextTasks: [AnyContextTask], postTasks: [AnyPostRoutingTask], postTaskRunner: PostTaskRunner<D>, logger: Logger?, destination: D) {
            self.factory = factory
            self.postTaskRunner = postTaskRunner
            self.postTasks = postTasks
            self.contextTasks = contextTasks
            self.logger = logger
            self.destination = destination
        }

        mutating func prepare(with context: Any?) throws {
            return try factory.prepare(with: context)
        }

        func build(with context: Any?) throws -> UIViewController {
            let viewController = try factory.build(with: context)
            if let context = context {
                try contextTasks.forEach({
                    try $0.apply(on: viewController, with: context, for: destination)
                })
            }
            postTasks.forEach({
                postTaskRunner?.taskSlips.append(PostTaskSlip(viewController: viewController, postTask: $0))
            })
            return viewController
        }

        mutating func scrapeChildren(from factories: [AnyFactory]) throws -> [AnyFactory] {
            return try factory.scrapeChildren(from: factories)
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

    private final class PostTaskRunner<D: RoutingDestination> {

        var taskSlips: [PostTaskSlip] = []

        func run(for destination: D) throws {
            var viewControllers:[UIViewController] = []
            taskSlips.forEach({
                guard let viewController = $0.viewController, !viewControllers.contains(viewController) else {
                    return
                }
                viewControllers.append(viewController)
            })

            try taskSlips.forEach({ slip in
                guard let viewController = slip.viewController else {
                    return
                }
                try slip.postTask.execute(on: viewController, for: destination, routingStack: viewControllers)
            })
        }
    }
}
