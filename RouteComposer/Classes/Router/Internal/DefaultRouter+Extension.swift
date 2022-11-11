//
// RouteComposer
// DefaultRouter+Extension.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
//

import Foundation
import UIKit

extension DefaultRouter {

    struct InterceptorRunner {

        private var interceptors: [(interceptor: AnyRoutingInterceptor, context: Any?)]

        init(interceptors: [AnyRoutingInterceptor], with context: Any?) throws {
            self.interceptors = try interceptors.map {
                var interceptor = $0
                try interceptor.prepare(with: context)
                return (interceptor: interceptor, context: context)
            }
        }

        mutating func add(_ interceptor: AnyRoutingInterceptor, with context: Any?) throws {
            var interceptor = interceptor
            try interceptor.prepare(with: context)
            interceptors.append((interceptor: interceptor, context: context))
        }

        func perform(completion: @escaping (_: RoutingResult) -> Void) {
            guard !interceptors.isEmpty else {
                completion(.success)
                return
            }

            var interceptors = interceptors

            func runInterceptor(interceptor: (interceptor: AnyRoutingInterceptor, context: Any?)) {
                interceptor.interceptor.perform(with: interceptor.context) { result in
                    if case .failure = result {
                        completion(result)
                    } else if interceptors.isEmpty {
                        completion(result)
                    } else {
                        runInterceptor(interceptor: interceptors.removeFirst())
                    }
                }
            }

            runInterceptor(interceptor: interceptors.removeFirst())
        }

    }

    struct ContextTaskRunner {

        var contextTasks: [(contextTask: AnyContextTask, context: Any?)]

        init(contextTasks: [AnyContextTask], with context: Any?) throws {
            self.contextTasks = try contextTasks.map {
                var contextTask = $0
                try contextTask.prepare(with: context)
                return (contextTask: contextTask, context: context)
            }
        }

        mutating func add(_ contextTask: AnyContextTask, with context: Any?) throws {
            var contextTask = contextTask
            try contextTask.prepare(with: context)
            contextTasks.append((contextTask: contextTask, context: context))
        }

        func perform(on viewController: UIViewController, with context: Any?) throws {
            try contextTasks.forEach {
                try $0.contextTask.perform(on: viewController, with: $0.context)
            }
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

        func commit(with context: Any?) throws {
            try postponedRunner.perform(with: context)
        }

    }

    struct StepTaskTaskRunner {

        private let contextTaskRunner: ContextTaskRunner

        private let postTaskRunner: PostTaskRunner

        private let context: Any?

        init(contextTaskRunner: ContextTaskRunner, postTaskRunner: PostTaskRunner, context: Any?) {
            self.contextTaskRunner = contextTaskRunner
            self.postTaskRunner = postTaskRunner
            self.context = context
        }

        func perform(on viewController: UIViewController) throws {
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

            func perform(on viewController: UIViewController, with context: Any?, routingStack: [UIViewController]) {}

        }

        private final var taskSlips: [PostTaskSlip] = []

        final func add(postTasks: [AnyPostRoutingTask], to viewController: UIViewController) {
            guard !postTasks.isEmpty else {
                let postTaskSlip = PostTaskSlip(viewController: viewController, postTask: EmptyPostTask())
                taskSlips.append(postTaskSlip)
                return
            }

            postTasks.forEach {
                let postTaskSlip = PostTaskSlip(viewController: viewController, postTask: $0)
                taskSlips.append(postTaskSlip)
            }
        }

        final func perform(with context: Any?) throws {
            var viewControllers: [UIViewController] = []
            taskSlips.forEach {
                guard let viewController = $0.viewController, !viewControllers.contains(viewController) else {
                    return
                }
                viewControllers.append(viewController)
            }

            try taskSlips.forEach { slip in
                guard let viewController = slip.viewController else {
                    return
                }
                try slip.postTask.perform(on: viewController, with: context, routingStack: viewControllers)
            }
        }
    }

    final class GlobalTaskRunner {

        private final var interceptorRunner: InterceptorRunner

        private final let contextTaskRunner: ContextTaskRunner

        private final let postTaskRunner: PostTaskRunner

        init(interceptorRunner: InterceptorRunner, contextTaskRunner: ContextTaskRunner, postTaskRunner: PostTaskRunner) {
            self.interceptorRunner = interceptorRunner
            self.contextTaskRunner = contextTaskRunner
            self.postTaskRunner = postTaskRunner
        }

        final func taskRunner(for step: PerformableStep?, with context: Any?) throws -> StepTaskTaskRunner {
            guard let interceptableStep = step as? InterceptableStep else {
                return StepTaskTaskRunner(contextTaskRunner: self.contextTaskRunner, postTaskRunner: self.postTaskRunner, context: context)
            }
            var contextTaskRunner = contextTaskRunner
            var postTaskRunner = postTaskRunner
            if let interceptor = interceptableStep.interceptor {
                try interceptorRunner.add(interceptor, with: context)
            }
            if let contextTask = interceptableStep.contextTask {
                try contextTaskRunner.add(contextTask, with: context)
            }
            if let postTask = interceptableStep.postTask {
                try postTaskRunner.add(postTask)
            }
            return StepTaskTaskRunner(contextTaskRunner: contextTaskRunner, postTaskRunner: postTaskRunner,context: context)
        }

        final func performInterceptors(completion: @escaping (_: RoutingResult) -> Void) {
            interceptorRunner.perform(completion: completion)
        }

        final func performPostTasks(with context: Any?) throws {
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

        mutating func prepare(with context: Any?) throws {
            try factory.prepare(with: context)
        }

        func build(with context: Any?) throws -> UIViewController {
            let viewController = try factory.build(with: context)
            try stepTaskRunner.perform(on: viewController)
            return viewController
        }

        mutating func scrapeChildren(from factories: [(factory: AnyFactory, context: Any?)]) throws -> [(factory: AnyFactory, context: Any?)] {
            try factory.scrapeChildren(from: factories)
        }

        var description: String {
            String(describing: factory)
        }

    }

    final class DefaultPostponedIntegrationHandler: PostponedActionIntegrationHandler, MainThreadChecking {

        private(set) final var containerViewController: ContainerViewController?

        private(set) final var postponedViewControllers: [UIViewController] = []

        final let logger: Logger?

        final let containerAdapterLocator: ContainerAdapterLocator

        init(logger: Logger?, containerAdapterLocator: ContainerAdapterLocator) {
            self.logger = logger
            self.containerAdapterLocator = containerAdapterLocator
        }

        final func update(containerViewController: ContainerViewController, animated: Bool, completion: @escaping (_: RoutingResult) -> Void) {
            do {
                guard self.containerViewController == nil else {
                    purge(animated: animated, completion: { result in
                        self.assertIfNotMainThread()
                        guard result.isSuccessful else {
                            completion(result)
                            return
                        }
                        self.update(containerViewController: containerViewController, animated: animated, completion: completion)
                    })
                    return
                }
                self.containerViewController = containerViewController
                postponedViewControllers = try containerAdapterLocator.getAdapter(for: containerViewController).containedViewControllers
                logger?.log(.info("Container \(String(describing: containerViewController)) will be used for the postponed integration."))
                completion(.success)
            } catch {
                completion(.failure(error))
            }
        }

        final func update(postponedViewControllers: [UIViewController]) {
            self.postponedViewControllers = postponedViewControllers
        }

        final func purge(animated: Bool, completion: @escaping (_: RoutingResult) -> Void) {
            do {
                guard let containerViewController = containerViewController else {
                    completion(.success)
                    return
                }

                let containerAdapter = try containerAdapterLocator.getAdapter(for: containerViewController)

                guard !postponedViewControllers.isEqual(to: containerAdapter.containedViewControllers) else {
                    reset()
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

        private final func reset() {
            containerViewController = nil
            postponedViewControllers = []
        }

    }

}
