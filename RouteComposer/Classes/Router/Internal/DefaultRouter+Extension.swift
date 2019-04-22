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

        func run<Context>(with context: Context, completion: @escaping (_: InterceptorResult) -> Void) {
            guard !interceptors.isEmpty else {
                completion(.continueRouting)
                return
            }
            let interceptorToRun = interceptors.count == 1 ? interceptors[0] : InterceptorMultiplexer(interceptors)
            interceptorToRun.execute(with: context, completion: completion)
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

        func run<Context>(on viewController: UIViewController, with context: Context) throws {
            try contextTasks.forEach({
                try $0.apply(on: viewController, with: context)
            })
        }

    }

    struct PostTaskRunner {

        var postTasks: [AnyPostRoutingTask]

        let postponedRunner: PostponedTaskRunner

        init<Context>(postTasks: [AnyPostRoutingTask], with context: Context, postponedRunner: PostponedTaskRunner) {
            self.postTasks = postTasks
            self.postponedRunner = postponedRunner
        }

        mutating func add<Context>(_ postTask: AnyPostRoutingTask, with context: Context) throws {
            postTasks.append(postTask)
        }

        func run<Context>(on viewController: UIViewController, with context: Context) throws {
            postponedRunner.add(postTasks: postTasks, to: viewController)
        }

        func commit<Context>(with context: Context) throws {
            try postponedRunner.run(with: context)
        }

    }

    struct StepTaskTaskRunner {

        private let contextTaskRunner: ContextTaskRunner

        private let postTaskRunner: PostTaskRunner

        init(contextTaskRunner: ContextTaskRunner, postTaskRunner: PostTaskRunner) {
            self.contextTaskRunner = contextTaskRunner
            self.postTaskRunner = postTaskRunner
        }

        func run<Context>(on viewController: UIViewController, with context: Context) throws {
            try contextTaskRunner.run(on: viewController, with: context)
            try postTaskRunner.run(on: viewController, with: context)
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

            func execute<Context>(on viewController: UIViewController, with context: Context, routingStack: [UIViewController]) {
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

        func run(with context: Any?) throws {
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
                try slip.postTask.execute(on: viewController, with: context, routingStack: viewControllers)
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

        func taskRunnerFor<Context>(step: PerformableStep?, with context: Context) throws -> StepTaskTaskRunner {
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
                try postTaskRunner.add(postTask, with: context)
            }
            return StepTaskTaskRunner(contextTaskRunner: contextTaskRunner, postTaskRunner: postTaskRunner)
        }

        func executeInterceptors<Context>(with context: Context, completion: @escaping (_: InterceptorResult) -> Void) {
            interceptorRunner.run(with: context, completion: completion)
        }

        func runPostTasks<Context>(with context: Context) throws {
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

        init(factory: AnyFactory, viewControllerTaskRunner: StepTaskTaskRunner) {
            self.factory = factory
            self.action = factory.action
            self.stepTaskRunner = viewControllerTaskRunner
        }

        mutating func prepare<Context>(with context: Context) throws {
            return try factory.prepare(with: context)
        }

        func build<Context>(with context: Context) throws -> UIViewController {
            let viewController = try factory.build(with: context)
            try stepTaskRunner.run(on: viewController, with: context)
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

        var containerViewController: ContainerViewController?

        var postponedViewControllers: [UIViewController] = []

        let logger: Logger?

        let containerAdapterProvider: ContainerAdapterProvider

        init(logger: Logger?, containerAdapterProvider: ContainerAdapterProvider) {
            self.logger = logger
            self.containerAdapterProvider = containerAdapterProvider
        }

        func update(containerViewController: ContainerViewController, animated: Bool, completion: @escaping (_: ActionResult) -> Void) throws {
            guard self.containerViewController == nil else {
                try purge(animated: animated, completion: {
                    do {
                        try self.update(containerViewController: containerViewController, animated: animated, completion: completion)
                    } catch let error {
                        completion(.failure(error))
                    }
                })
                return
            }
            self.containerViewController = containerViewController
            self.postponedViewControllers = try containerAdapterProvider.getAdapter(for: containerViewController).containedViewControllers
            logger?.log(.info("Container \(String(describing: containerViewController)) will be used for the postponed integration."))
            completion(.continueRouting)
        }

        func update(postponedViewControllers: [UIViewController]) {
            self.postponedViewControllers = postponedViewControllers
        }

        func purge(animated: Bool, completion: @escaping () -> Void) throws {
            guard let containerViewController = containerViewController else {
                completion()
                return
            }

            let containerAdapter = try containerAdapterProvider.getAdapter(for: containerViewController)

            guard !postponedViewControllers.isEqual(to: containerAdapter.containedViewControllers) else {
                self.reset()
                completion()
                return
            }

            try containerAdapter.setContainedViewControllers(postponedViewControllers,
                    animated: animated,
                    completion: {
                        self.logger?.log(.info("View controllers \(String(describing: self.postponedViewControllers)) were simultaneously "
                                + "integrated into \(containerViewController)"))
                        self.reset()
                        completion()
                    })
        }

        private func reset() {
            containerViewController = nil
            postponedViewControllers = []
        }

    }

}
