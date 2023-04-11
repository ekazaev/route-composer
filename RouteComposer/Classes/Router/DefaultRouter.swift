//
// RouteComposer
// DefaultRouter.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import UIKit

/// Default `Router` implementation
public struct DefaultRouter: InterceptableRouter, MainThreadChecking {

    // MARK: Properties

    /// `Logger` instance to be used by `DefaultRouter`.
    public let logger: Logger?

    /// `ContainerAdapter` instance.
    public let containerAdapterLocator: ContainerAdapterLocator

    /// `StackPresentationHandler` instance
    public let stackPresentationHandler: StackPresentationHandler

    private var interceptors: [AnyRoutingInterceptor] = []

    private var contextTasks: [AnyContextTask] = []

    private var postTasks: [AnyPostRoutingTask] = []

    // MARK: Methods

    /// Constructor
    ///
    /// Parameters
    ///   - logger: A `Logger` instance to be used by the `DefaultRouter`.
    ///   - stackPresentationHandler: A `StackPresentationHandler` instance to be used by the `DefaultRouter`.
    ///   - containerAdapterLocator: A `ContainerAdapterLocator` instance to be used by the `DefaultRouter`.
    public init(logger: Logger? = RouteComposerDefaults.shared.logger,
                stackPresentationHandler: StackPresentationHandler = DefaultStackPresentationHandler(),
                containerAdapterLocator: ContainerAdapterLocator = RouteComposerDefaults.shared.containerAdapterLocator) {
        self.logger = logger
        self.stackPresentationHandler = stackPresentationHandler
        self.containerAdapterLocator = containerAdapterLocator
    }

    public mutating func add<RI: RoutingInterceptor>(_ interceptor: RI) where RI.Context == Any? {
        interceptors.append(RoutingInterceptorBox(interceptor))
    }

    public mutating func add<CT: ContextTask>(_ contextTask: CT) where CT.Context == Any? {
        contextTasks.append(ContextTaskBox(contextTask))
    }

    public mutating func add<PT: PostRoutingTask>(_ postTask: PT) where PT.Context == Any? {
        postTasks.append(PostRoutingTaskBox(postTask))
    }

    public func navigate<Context>(to step: DestinationStep<some UIViewController, Context>,
                                  with context: Context,
                                  animated: Bool = true,
                                  completion: ((_: RoutingResult) -> Void)? = nil) throws {
        assertIfNotMainThread(logger: logger)
        do {
            // Wrapping real context into a box.
            let context: AnyContext = AnyContextBox(context)

            let taskStack = try prepareTaskStack(with: context)
            let navigationStack = try prepareFactoriesStack(to: step, with: context, taskStack: taskStack)

            let viewController = navigationStack.rootViewController
            let buildingInputStack = navigationStack.buildingInputStack

            // Checks if the view controllers that are currently presented from the origin view controller, can be dismissed.
            if let viewController = Array([[viewController.allParents.last ?? viewController], viewController.allPresentedViewControllers].joined()).nonDismissibleViewController {
                throw RoutingError.cantBeDismissed(.init("\(String(describing: viewController)) view controller cannot " +
                        "be dismissed."))
            }

            startNavigation(from: viewController,
                            building: buildingInputStack,
                            performing: taskStack,
                            animated: animated,
                            completion: { (result: RoutingResult) in
                                if case let .failure(error) = result {
                                    logger?.log(.error("\(error)"))
                                    logger?.log(.info("Unsuccessfully finished the navigation process."))
                                } else {
                                    logger?.log(.info("Successfully finished the navigation process."))
                                }
                                completion?(result)
                            })
        } catch {
            logger?.log(.error("\(error)"))
            logger?.log(.info("Unsuccessfully finished the navigation process."))
            throw error
        }
    }

    // MARK: Private Methods

    private func prepareTaskStack(with context: AnyContext) throws -> GlobalTaskRunner {
        let interceptorRunner = try InterceptorRunner(interceptors: interceptors, with: context)
        let contextTaskRunner = try ContextTaskRunner(contextTasks: contextTasks, with: context)
        let postponedTaskRunner = PostponedTaskRunner()
        let postTaskRunner = PostTaskRunner(postTasks: postTasks, postponedRunner: postponedTaskRunner)
        return GlobalTaskRunner(interceptorRunner: interceptorRunner, contextTaskRunner: contextTaskRunner, postTaskRunner: postTaskRunner)
    }

    private func prepareFactoriesStack(to finalStep: RoutingStep, with context: AnyContext, taskStack: GlobalTaskRunner) throws -> (rootViewController: UIViewController,
                                                                                                                                    buildingInputStack: [(factory: AnyFactory, context: AnyContext)]) {
        logger?.log(.info("Started to search for the view controller to start the navigation process from."))

        var context = context

        let stepSequence = sequence(first: finalStep, next: { ($0 as? ChainableStep)?.getPreviousStep(with: context) }).compactMap { $0 as? PerformableStep }

        let result = try stepSequence.reduce((rootViewController: UIViewController?, buildingInputStack: [(factory: AnyFactory, context: AnyContext)])(rootViewController: nil, buildingInputStack: [])) { result, step in
            guard result.rootViewController == nil else {
                return result
            }

            // Creates a class responsible to run the tasks for this particular step
            let stepTaskRunner = try taskStack.taskRunner(for: step, with: context)

            switch try step.perform(with: context) {
            case let .success(viewController):
                logger?.log(.info("\(String(describing: step)) found " +
                        "\(String(describing: viewController)) to start the navigation process from."))

                try stepTaskRunner.perform(on: viewController)

                return (rootViewController: viewController, result.buildingInputStack)
            case let .build(originalFactory):
                logger?.log(.info("\(String(describing: step)) hasn't found a corresponding view " +
                        "controller in the stack, so it will be built using \(String(describing: originalFactory))."))

                // Wrap the `Factory` with the decorator that will
                // handle the view controller and post task chain after the view controller creation.
                var factory = FactoryDecorator(factory: originalFactory, stepTaskRunner: stepTaskRunner)

                // Prepares the `Factory` for integration
                // If a `Factory` cannot prepare itself (e.g. does not have enough data in context)
                // then the view controllers stack can not be built
                try factory.prepare(with: context)

                // Allows to the `Factory` to change the current factory stack if needed.
                var buildingInputStack = try factory.scrapeChildren(from: result.buildingInputStack)

                // Adds the `Factory` to the beginning of the stack as the router is reading the configuration backwards.
                buildingInputStack.insert((factory: factory, context: context), at: 0)
                return (rootViewController: result.rootViewController, buildingInputStack: buildingInputStack)
            case let .updateContext(newContext):
                // Substitute current context with an updated one
                context = newContext
                return result
            case .none:
                logger?.log(.info("\(String(describing: step)) hasn't found a corresponding view " +
                        "controller in the stack, so router will continue to search."))
                return result
            }
        }

        // Throw an exception if the router hasn't found a view controller to start the stack from.
        guard let rootViewController = result.rootViewController else {
            throw RoutingError.initialController(.notFound, .init("Unable to start the navigation process as the view controller to start from was not found."))
        }

        return (rootViewController: rootViewController, buildingInputStack: result.buildingInputStack)
    }

    private func startNavigation(from viewController: UIViewController,
                                 building buildingInputStack: [(factory: AnyFactory, context: AnyContext)],
                                 performing taskStack: GlobalTaskRunner,
                                 animated: Bool,
                                 completion: @escaping (RoutingResult) -> Void) {
        // Executes interceptors associated to each view in the chain. All the interceptors must succeed to
        // continue navigation process. This operation is async.
        let initialControllerDescription = String(describing: viewController)
        taskStack.performInterceptors { [weak viewController] result in
            assertIfNotMainThread(logger: logger)

            if case let .failure(error) = result {
                completion(.failure(error))
                return
            }

            guard let viewController else {
                completion(.failure(RoutingError.initialController(.deallocated, .init("A view controller \(initialControllerDescription) that has been chosen as a " +
                        "starting point of the navigation process was destroyed while the router was waiting for the interceptors to finish."))))
                return
            }

            // Closes all the presented view controllers above the found view controller to be able
            // to build a new stack if needed.
            // This operation is async.
            // It was already confirmed that they can be dismissed.
            stackPresentationHandler.dismissPresented(from: viewController, animated: animated) { result in
                guard result.isSuccessful else {
                    completion(result)
                    return
                }

                // Builds view controller's stack using factories.
                // This operation is async.
                buildViewControllerStack(starting: viewController,
                                         using: buildingInputStack,
                                         animated: animated) { result in
                    do {
                        if case let .failure(error) = result {
                            throw error
                        }
                        try taskStack.performPostTasks()
                        completion(result)
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
    }

    // Loops through the list of factories and builds their view controllers in sequence.
    // Some actions can be asynchronous, like push, modal or presentations,
    // so it performs them asynchronously
    private func buildViewControllerStack(starting rootViewController: UIViewController,
                                          using factories: [(factory: AnyFactory, context: AnyContext)],
                                          animated: Bool,
                                          completion: @escaping (RoutingResult) -> Void) {
        var factories = factories
        let postponedIntegrationHandler = DefaultPostponedIntegrationHandler(logger: logger,
                                                                             containerAdapterLocator: containerAdapterLocator)

        func buildViewController(from previousViewController: UIViewController) {
            stackPresentationHandler.makeVisibleInParentContainers(previousViewController, animated: animated) { result in
                guard result.isSuccessful else {
                    logger?.log(.info("\(String(describing: previousViewController)) has stopped the navigation process " +
                            "as it was not able to become active."))
                    completion(result)
                    return
                }
                guard !factories.isEmpty else {
                    postponedIntegrationHandler.purge(animated: animated, completion: completion)
                    return
                }
                do {
                    let factory = factories.removeFirst()
                    let newViewController = try factory.factory.build(with: factory.context)
                    logger?.log(.info("\(String(describing: factory)) built a \(String(describing: newViewController))."))

                    let nextAction = factories.first?.factory.action

                    factory.factory.action.perform(with: newViewController,
                                                   on: previousViewController,
                                                   with: postponedIntegrationHandler,
                                                   nextAction: nextAction,
                                                   animated: animated) { result in
                        assertIfNotMainThread(logger: logger)
                        guard result.isSuccessful else {
                            logger?.log(.info("\(String(describing: factory.factory.action)) has stopped the navigation process " +
                                    "as it was not able to build a view controller into a stack."))
                            completion(result)
                            return
                        }
                        logger?.log(.info("\(String(describing: factory.factory.action)) has applied to " +
                                "\(String(describing: previousViewController)) with \(String(describing: newViewController))."))
                        buildViewController(from: newViewController)
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }

        logger?.log(.info(factories.isEmpty ? "No view controllers needed to be integrated into the stack." : "Started to build the view controllers stack."))
        buildViewController(from: rootViewController)
    }

}
