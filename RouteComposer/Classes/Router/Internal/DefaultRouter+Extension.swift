//
// Created by Eugene Kazaev on 04/09/2018.
//

import Foundation
import UIKit

extension DefaultRouter {

    struct InterceptorRunner {

        private var interceptors: [AnyRoutingInterceptor]

        let context: Any?

        init(interceptors: [AnyRoutingInterceptor], context: Any?) throws {
            self.context = context
            self.interceptors = try interceptors.map({
                var interceptor = $0
                try interceptor.prepare(with: context)
                return interceptor
            })
        }

        mutating func add(_ interceptor: AnyRoutingInterceptor) throws {
            var interceptor = interceptor
            try interceptor.prepare(with: context)
            interceptors.append(interceptor)
        }

        func run(completion: @escaping (_: InterceptorResult) -> Void) {
            guard !interceptors.isEmpty else {
                completion(.success)
                return
            }
            let interceptorToRun = interceptors.count == 1 ? interceptors[0] : InterceptorMultiplexer(interceptors)
            interceptorToRun.execute(with: context, completion: completion)
        }

    }

    struct ContextTaskRunner {

        var contextTasks: [AnyContextTask]

        let context: Any?

        init(contextTasks: [AnyContextTask], context: Any?) throws {
            self.context = context
            self.contextTasks = try contextTasks.map({
                var contextTask = $0
                try contextTask.prepare(with: context)
                return contextTask
            })
        }

        mutating func add(_ contextTask: AnyContextTask) throws {
            var contextTask = contextTask
            try contextTask.prepare(with: context)
            contextTasks.append(contextTask)
        }

        func run(on viewController: UIViewController) throws {
            try contextTasks.forEach({
                try $0.apply(on: viewController, with: context)
            })
        }

    }

    struct PostTaskRunner {

        var postTasks: [AnyPostRoutingTask]

        let context: Any?

        let delayedRunner: PostTaskDelayedRunner

        init(postTasks: [AnyPostRoutingTask], context: Any?, delayedRunner: PostTaskDelayedRunner) {
            self.context = context
            self.postTasks = postTasks
            self.delayedRunner = delayedRunner
        }

        mutating func add(_ postTask: AnyPostRoutingTask) throws {
            postTasks.append(postTask)
        }

        func run(on viewController: UIViewController) throws {
            delayedRunner.add(postTasks: postTasks, to: viewController)
        }

        func commit() throws {
            try delayedRunner.run(with: context)
        }

    }

    struct StepTaskTaskRunner {

        private let contextTaskRunner: ContextTaskRunner

        private let postTaskRunner: PostTaskRunner

        init(contextTaskRunner: ContextTaskRunner, postTaskRunner: PostTaskRunner) {
            self.contextTaskRunner = contextTaskRunner
            self.postTaskRunner = postTaskRunner
        }

        func run(on viewController: UIViewController) throws {
            try contextTaskRunner.run(on: viewController)
            try postTaskRunner.run(on: viewController)
        }

    }

    final class PostTaskDelayedRunner {

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

            func execute(on viewController: UIViewController, with context: Any?, routingStack: [UIViewController]) {
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

        func taskRunnerFor(step: RoutingStep?) throws -> StepTaskTaskRunner {
            guard let interceptableStep = step as? InterceptableStep else {
                return StepTaskTaskRunner(contextTaskRunner: self.contextTaskRunner, postTaskRunner: self.postTaskRunner)
            }
            var contextTaskRunner = self.contextTaskRunner
            var postTaskRunner = self.postTaskRunner
            if let interceptor = interceptableStep.interceptor {
                try interceptorRunner.add(interceptor)
            }
            if let contextTask = interceptableStep.contextTask {
                try contextTaskRunner.add(contextTask)
            }
            if let postTask = interceptableStep.postTask {
                try postTaskRunner.add(postTask)
            }
            return StepTaskTaskRunner(contextTaskRunner: contextTaskRunner, postTaskRunner: postTaskRunner)
        }

        func executeInterceptors(completion: @escaping (_: InterceptorResult) -> Void) {
            interceptorRunner.run(completion: completion)
        }

        func runPostTasks() throws {
            try postTaskRunner.commit()
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

        mutating func prepare(with context: Any?) throws {
            return try factory.prepare(with: context)
        }

        func build(with context: Any?) throws -> UIViewController {
            let viewController = try factory.build(with: context)
            try stepTaskRunner.run(on: viewController)
            return viewController
        }

        mutating func scrapeChildren(from factories: [AnyFactory]) throws -> [AnyFactory] {
            return try factory.scrapeChildren(from: factories)
        }

        var description: String {
            return String(describing: factory)
        }

    }

    final class DefaultDelayedIntegrationHandler: DelayedActionIntegrationHandler {

        var containerViewController: ContainerViewController?

        var delayedViewControllers: [UIViewController] = []

        let logger: Logger?
        
        init(logger: Logger?) {
            self.logger = logger
        }

        func update(containerViewController: ContainerViewController, animated: Bool, completion: @escaping () -> Void) {
            guard self.containerViewController == nil else {
                purge(animated: animated, completion: {
                    self.update(containerViewController: containerViewController, animated: animated, completion: completion)
                })
                return
            }
            self.containerViewController = containerViewController
            self.delayedViewControllers = containerViewController.containedViewControllers
            logger?.log(.info("Container \(String(describing: containerViewController)) will be used for the delayed integration."))
            completion()
        }

        func update(delayedViewControllers: [UIViewController]) {
            self.delayedViewControllers = delayedViewControllers
        }

        func purge(animated: Bool, completion: @escaping () -> Void) {
            guard let containerViewController = containerViewController else {
                completion()
                return
            }

            guard !delayedViewControllers.isEqual(to: containerViewController.containedViewControllers) else {
                self.containerViewController = nil
                self.delayedViewControllers = []
                completion()
                return
            }

            containerViewController.replace(containedViewControllers: delayedViewControllers, animated: animated, completion: {
                self.logger?.log(.info("View controllers \(String(describing: self.delayedViewControllers)) were integrated together into \(containerViewController)"))
                self.containerViewController = nil
                self.delayedViewControllers = []
                completion()
            })
        }

    }

}
