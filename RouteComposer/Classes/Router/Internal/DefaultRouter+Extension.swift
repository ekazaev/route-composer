//
// Created by Eugene Kazaev on 04/09/2018.
//

import Foundation
import UIKit

extension DefaultRouter {

    struct InterceptorRunner {

        private var interceptors: [AnyRoutingInterceptor]

        init<Context>(interceptors: [AnyRoutingInterceptor], with context: Context) throws {
            self.interceptors = try interceptors.map({
                var interceptor = $0
                try interceptor.prepare(with: context)
                return interceptor
            })
        }

        mutating func add<Context>(_ interceptor: AnyRoutingInterceptor, with context: Context) throws {
            var interceptor = interceptor
            try interceptor.prepare(with: context)
            interceptors.append(interceptor)
        }

        func perform<Context>(with context: Context, completion: @escaping (_: RoutingResult) -> Void) {
            guard !interceptors.isEmpty else {
                completion(.success)
                return
            }
            let interceptorToRun = interceptors.count == 1 ? interceptors[0] : InterceptorMultiplexer(interceptors)
            interceptorToRun.perform(with: context, completion: completion)
        }

    }

    struct ContextTaskRunner {

        var contextTasks: [AnyContextTask]

        init<Context>(contextTasks: [AnyContextTask], with context: Context) throws {
            self.contextTasks = try contextTasks.map({
                var contextTask = $0
                try contextTask.prepare(with: context)
                return contextTask
            })
        }

        mutating func add<Context>(_ contextTask: AnyContextTask, with context: Context) throws {
            var contextTask = contextTask
            try contextTask.prepare(with: context)
            contextTasks.append(contextTask)
        }

        func perform<Context>(on viewController: UIViewController, with context: Context) throws {
            try contextTasks.forEach({
                try $0.perform(on: viewController, with: context)
            })
        }

    }

    struct PostTaskRunner {

        var postTasks: [AnyPostRoutingTask]

        let postponedRunner: PostponedTaskRunner

        init(postTasks: [AnyPostRoutingTask], postponedRunner: PostponedTaskRunner) {
            self.postTasks = postTasks
            self.postponedRunner = postponedRunner
        }

        mutating func add(_ postTask: AnyPostRoutingTask) throws {
            postTasks.append(postTask)
        }

        func perform(on viewController: UIViewController) throws {
            postponedRunner.add(postTasks: postTasks, to: viewController)
        }

        func commit<Context>(with context: Context) throws {
            try postponedRunner.perform(with: context)
        }

    }

    struct StepTaskTaskRunner {

        private let contextTaskRunner: ContextTaskRunner

        private let postTaskRunner: PostTaskRunner

        init(contextTaskRunner: ContextTaskRunner, postTaskRunner: PostTaskRunner) {
            self.contextTaskRunner = contextTaskRunner
            self.postTaskRunner = postTaskRunner
        }

        func perform<Context>(on viewController: UIViewController, with context: Context) throws {
            try contextTaskRunner.perform(on: viewController, with: context)
            try postTaskRunner.perform(on: viewController)
        }

    }

    final class PostponedTaskRunner {

        private struct PostTaskSlip {
            // This reference is weak because even though this view controller was created by a fabric but then some other
            // view controller in the chain can have an action that will actually remove this view controller from the
            // stack. We do not want to keep a strong reference to it and prevent it from deallocation. Potentially it's
            // a very rare issue but must be kept in mind.
            weak var viewController: UIViewController?

            let postTask: AnyPostRoutingTask
        }

        // this class is just a placeholder. Router needs at least one post routing task per view controller to
        // store a reference there.
        private struct EmptyPostTask: AnyPostRoutingTask {

            func perform<Context>(on viewController: UIViewController, with context: Context, routingStack: [UIViewController]) {
            }

        }

        private var taskSlips: [PostTaskSlip] = []

        func add(postTasks: [AnyPostRoutingTask], to viewController: UIViewController) {
            guard !postTasks.isEmpty else {
                let postTaskSlip = PostTaskSlip(viewController: viewController, postTask: EmptyPostTask())
                taskSlips.append(postTaskSlip)
                return
            }

            postTasks.forEach({
                let postTaskSlip = PostTaskSlip(viewController: viewController, postTask: $0)
                taskSlips.append(postTaskSlip)
            })
        }

        func perform<Context>(with context: Context) throws {
            var viewControllers: [UIViewController] = []
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
                try slip.postTask.perform(on: viewController, with: context, routingStack: viewControllers)
            })
        }
    }

    class GlobalTaskRunner {

        private var interceptorRunner: InterceptorRunner

        private let contextTaskRunner: ContextTaskRunner

        private let postTaskRunner: PostTaskRunner

        init(interceptorRunner: InterceptorRunner, contextTaskRunner: ContextTaskRunner, postTaskRunner: PostTaskRunner) {
            self.interceptorRunner = interceptorRunner
            self.contextTaskRunner = contextTaskRunner
            self.postTaskRunner = postTaskRunner
        }

        func taskRunner<Context>(for step: PerformableStep?, with context: Context) throws -> StepTaskTaskRunner {
            guard let interceptableStep = step as? InterceptableStep else {
                return StepTaskTaskRunner(contextTaskRunner: self.contextTaskRunner, postTaskRunner: self.postTaskRunner)
            }
            var contextTaskRunner = self.contextTaskRunner
            var postTaskRunner = self.postTaskRunner
            if let interceptor = interceptableStep.interceptor {
                try interceptorRunner.add(interceptor, with: context)
            }
            if let contextTask = interceptableStep.contextTask {
                try contextTaskRunner.add(contextTask, with: context)
            }
            if let postTask = interceptableStep.postTask {
                try postTaskRunner.add(postTask)
            }
            return StepTaskTaskRunner(contextTaskRunner: contextTaskRunner, postTaskRunner: postTaskRunner)
        }

        func performInterceptors<Context>(with context: Context, completion: @escaping (_: RoutingResult) -> Void) {
            interceptorRunner.perform(with: context, completion: completion)
        }

        func performPostTasks<Context>(with context: Context) throws {
            try postTaskRunner.commit(with: context)
        }

    }

    /// Each post action needs to know a view controller is should be applied to.
    /// This decorator adds functionality of storing `UIViewController`s created by the `Factory` and frees
    /// custom factories implementations from dealing with it. Mostly it is important for ContainerFactories
    /// which create merged view controllers without `Router`'s help.
    struct FactoryDecorator: AnyFactory, CustomStringConvertible {

        private var factory: AnyFactory

        private let stepTaskRunner: StepTaskTaskRunner

        let action: AnyAction

        init(factory: AnyFactory, stepTaskRunner: StepTaskTaskRunner) {
            self.factory = factory
            self.action = factory.action
            self.stepTaskRunner = stepTaskRunner
        }

        mutating func prepare<Context>(with context: Context) throws {
            return try factory.prepare(with: context)
        }

        func build<Context>(with context: Context) throws -> UIViewController {
            let viewController = try factory.build(with: context)
            try stepTaskRunner.perform(on: viewController, with: context)
            return viewController
        }

        mutating func scrapeChildren(from factories: [AnyFactory]) throws -> [AnyFactory] {
            return try factory.scrapeChildren(from: factories)
        }

        var description: String {
            return String(describing: factory)
        }

    }

    final class DefaultPostponedIntegrationHandler: PostponedActionIntegrationHandler {

        private(set) var containerViewController: ContainerViewController?

        private(set) var postponedViewControllers: [UIViewController] = []

        let logger: Logger?

        let containerAdapterLocator: ContainerAdapterLocator

        init(logger: Logger?, containerAdapterLocator: ContainerAdapterLocator) {
            self.logger = logger
            self.containerAdapterLocator = containerAdapterLocator
        }

        func update(containerViewController: ContainerViewController, animated: Bool, completion: @escaping (_: RoutingResult) -> Void) {
            do {
                guard self.containerViewController == nil else {
                    purge(animated: animated, completion: { result in
                        guard result.isSuccessful else {
                            return completion(result)
                        }
                        self.update(containerViewController: containerViewController, animated: animated, completion: completion)
                    })
                    return
                }
                self.containerViewController = containerViewController
                self.postponedViewControllers = try containerAdapterLocator.getAdapter(for: containerViewController).containedViewControllers
                logger?.log(.info("Container \(String(describing: containerViewController)) will be used for the postponed integration."))
                completion(.success)
            } catch {
                completion(.failure(error))
            }
        }

        func update(postponedViewControllers: [UIViewController]) {
            self.postponedViewControllers = postponedViewControllers
        }

        func purge(animated: Bool, completion: @escaping (_: RoutingResult) -> Void) {
            do {
                guard let containerViewController = containerViewController else {
                    completion(.success)
                    return
                }

                let containerAdapter = try containerAdapterLocator.getAdapter(for: containerViewController)

                guard !postponedViewControllers.isEqual(to: containerAdapter.containedViewControllers) else {
                    self.reset()
                    completion(.success)
                    return
                }

                containerAdapter.setContainedViewControllers(postponedViewControllers,
                        animated: animated,
                        completion: { result in
                            guard result.isSuccessful else {
                                completion(result)
                                return
                            }
                            self.logger?.log(.info("View controllers \(String(describing: self.postponedViewControllers)) were simultaneously "
                                    + "integrated into \(String(describing: containerViewController))"))
                            self.reset()
                            completion(.success)
                        })
            } catch {
                completion(.failure(error))
            }
        }

        private func reset() {
            containerViewController = nil
            postponedViewControllers = []
        }

    }

}
