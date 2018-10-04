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

    public func navigate<ViewController: UIViewController, Context>(to step: DestinationStep<ViewController, Context>,
                                                                    with context: Context,
                                                                    animated: Bool = true,
                                                                    completion: ((_: RoutingResult) -> Void)? = nil) throws {
        guard Thread.isMainThread else {
            throw RoutingError.message("An attempt to call UI API not on the main thread.")
        }

        // If currently visible view controller can not be dismissed then we can't route anywhere, because it will
        // disappear as a result of routing.
        if let topMostViewController = UIWindow.key?.topmostViewController as? RoutingInterceptable,
           !topMostViewController.canBeDismissed {
            throw RoutingError.message("The topmost view controller can not be dismissed.")
        }

        let taskStack = try prepareTaskStack(with: context)

        // Build stack of factories and find a view controller to start a presentation process from.
        // Returns (rootViewController, factories, interceptor) tuple
        // where rootViewController is the origin of the chain of views to be built for a given destination.
        let navigationStack = try prepareFactoriesStack(to: step, with: context, taskStack: taskStack)

        let viewController = navigationStack.rootViewController,
                factoriesStack = navigationStack.factories

        // check if the view controllers, that are currently presented from the origin view controller for a
        // given destination, can be dismissed.
        if let viewController = Array([[viewController], viewController.allPresentedViewControllers].joined()).nonDismissibleViewController {
            throw RoutingError.message("\(String(describing: viewController)) view controller can not be dismissed.")
        }

        // Execute interceptors associated to the each view in the chain. All of interceptors must succeed to
        // continue routing. This operation is async.
        taskStack.runInterceptors { [weak viewController] result in
            func failGracefully(_ message: String) {
                self.logger?.log(LoggerMessage.error(message))
                completion?(.unhandled(RoutingError.message(message)))
            }

            if case let .failure(message) = result {
                return failGracefully(message ?? "An interceptor has stopped routing process.")
            }

            guard Thread.isMainThread else {
                return failGracefully("An attempt to call UI API not on the main thread.")
            }

            guard let viewController = viewController else {
                return failGracefully("A view controller that has been chosen as a starting point of the navigation process " +
                        "was destroyed while router was waiting for the interceptors to finish.")
            }

            // If we found a view controller to start from - lets close all the presented view controllers above to be able
            // to build a new stack if needed. This operation is async.
            // We already checked that they can be dismissed.
            self.dismissPresentedIfNeeded(from: viewController, animated: animated) {
                // Now we can start building view controller's stack using factories.
                // This operation is async.
                self.runViewControllerBuildStack(starting: viewController,
                        with: context,
                        using: factoriesStack,
                        animated: animated) { viewController, result in
                    // Even if the result is unhandled - we still have to run all the tasks
                    self.makeVisibleInParentContainer(viewController, animated: animated)
                    do {
                        try taskStack.runPostTasks()
                        self.logger?.log(.info("Successfully finished the navigation process."))
                        completion?(.handled)
                    } catch let error {
                        self.logger?.log(.info("Unsuccessfully finished the navigation process."))
                        completion?(.unhandled(error))
                    }
                }
            }
        }
    }

    private func prepareTaskStack(with context: Any?) throws -> GlobalTaskRunner {
        let interceptorRunner = try InterceptorRunner(interceptors: self.interceptors, context: context)
        let contextTaskRunner = try ContextTaskRunner(contextTasks: self.contextTasks, context: context)
        let postTaskDelayedRunner = PostTaskDelayedRunner()
        let postTaskRunner = PostTaskRunner(postTasks: self.postTasks, context: context, delayedRunner: postTaskDelayedRunner)
        return GlobalTaskRunner(interceptorRunner: interceptorRunner, contextTaskRunner: contextTaskRunner, postTaskRunner: postTaskRunner)
    }

    private func prepareFactoriesStack(to finalStep: RoutingStep, with context: Any?, taskStack: GlobalTaskRunner) throws -> (rootViewController: UIViewController,
                                                                                                                              factories: [AnyFactory]) {
        var viewControllerToStart: UIViewController?

        var factories: [AnyFactory] = []

        var currentStep: RoutingStep? = finalStep

        logger?.log(.info("Started to look for the view controller to start the navigation process from."))

        // Build stack until we have steps and the view controller to present from is not found
        repeat {
            if let performableStep = currentStep as? PerformableStep {

                // Create class responsible to run the tasks for this particular step
                let viewControllerTaskRunner = try taskStack.taskRunnerFor(step: currentStep)

                // Trying to find a view controller to start building the stack from
                switch try performableStep.perform(with: context) {
                case .success(let viewController):
                    viewControllerToStart = viewController
                    logger?.log(.info("\(String(describing: performableStep)) found " +
                            "\(String(describing: viewController)) to start the navigation process from."))
                    try viewControllerTaskRunner.run(on: viewController)
                case .continueRouting(let factory):
                    // If view controller to start from is not found, but step has a `Factory` to build itself -
                    // add factory to the stack
                    logger?.log(.info("\(String(describing: performableStep)) not found a corresponding view " +
                            "controller in the stack, so router will continue to search."))
                    if var factory = factory {
                        // If step contains post task, them lets create a `Factory` decorator that will
                        // handle view controller and post task chain after view controller creation.
                        factory = FactoryDecorator(factory: factory,
                                viewControllerTaskRunner: viewControllerTaskRunner)

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
            }

            guard viewControllerToStart == nil,
                  let chainingStep = currentStep as? ChainableStep,
                  let previousStep = chainingStep.previousStep else {
                break
            }
            currentStep = previousStep
        } while currentStep != nil

        //If we haven't found a View Controller to build the stack from - it means that we can't handle routing.
        guard let viewController = viewControllerToStart else {
            throw RoutingError.message("Unable to start the navigation process as a view controller to start from is not found.")
        }

        return (rootViewController: viewController, factories: factories)
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
            // If the previous view controller created/found but it's view is not loaded or has no window that it
            // belongs to, means that it was just cached by container view controller like in UITabBarController
            // controller in a tab that was never activated before. So we have to make it active first.
            // Example: TabBar contains navigation controller in the tab that was never opened and we are going
            // to push in to it, UINavigationController in this case will not be able to update it content properly.
            if !previousViewController.isViewLoaded || previousViewController.view.window == nil {
                makeVisibleInParentContainer(previousViewController, animated: false)
            }

            do {
                let newViewController = try factory.build(with: context)
                logger?.log(.info("\(String(describing: factory)) built a " +
                        "\(String(describing: newViewController))."))
                factory.action.perform(with: newViewController, on: previousViewController, animated: animated) { result in
                    if case let .failure(actionMessage) = result {
                        let message = actionMessage ?? "\(String(describing: factory.action)) stopped " +
                                "the navigation process as it was not able to build a view controller in to a stack."
                        self.logger?.log(.error(message))
                        completion(newViewController, .unhandled(RoutingError.message(message)))
                        return
                    }
                    self.logger?.log(.info("\(String(describing: factory.action)) has applied to " +
                            "\(String(describing: previousViewController)) with " +
                            "\(String(describing: newViewController))."))
                    buildViewController(from: newViewController)
                }
            } catch let error {
                completion(previousViewController, .unhandled(error))
            }
        }

        logger?.log(.info("Started to build the view controller's stack."))
        buildViewController(from: rootViewController)
    }

    // this function activates the origin view controller of viewController
    private func makeVisibleInParentContainer(_ viewController: UIViewController, animated: Bool) {
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

}
