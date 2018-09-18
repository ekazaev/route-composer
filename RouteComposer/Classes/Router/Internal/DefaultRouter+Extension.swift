//
// Created by Eugene Kazaev on 04/09/2018.
//

import Foundation
import UIKit

extension DefaultRouter {

    private struct PostTaskSlip {
        // This reference is weak because even though this view controller was created by a fabric but then some other
        // view controller in the chain can have an action that will actually remove this view controller from the
        // stack. We do not want to keep a strong reference to it and prevent it from deallocation. Potentially it's
        // a very rare issue but must be kept in mind.
        weak var viewController: UIViewController?

        let postTask: AnyPostRoutingTask
    }

    final class PostTaskRunner {

        private var taskSlips: [PostTaskSlip] = []

        func add(viewController: UIViewController?, postTask: AnyPostRoutingTask) {
            let postTaskSlip = PostTaskSlip(viewController: viewController, postTask: postTask)
            taskSlips.append(postTaskSlip)
        }

        func run(for context: Any?) throws {
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

    /// Each post action needs to know a view controller is should be applied to.
    /// This decorator adds functionality of storing UIViewControllers created by the `Factory` and frees
    /// custom factories implementations from dealing with it. Mostly it is important for ContainerFactories
    /// which create merged view controllers without `Router`'s help.
    struct FactoryDecorator: AnyFactory, CustomStringConvertible {

        var factory: AnyFactory

        weak var postTaskRunner: PostTaskRunner?

        let contextTasks: [AnyContextTask]

        let postTasks: [AnyPostRoutingTask]

        let logger: Logger?

        let action: AnyAction

        init(factory: AnyFactory,
             contextTasks: [AnyContextTask],
             postTasks: [AnyPostRoutingTask],
             postTaskRunner: PostTaskRunner,
             logger: Logger?) {
            self.factory = factory
            self.action = factory.action
            self.postTaskRunner = postTaskRunner
            self.postTasks = postTasks
            self.contextTasks = contextTasks
            self.logger = logger
        }

        mutating func prepare(with context: Any?) throws {
            return try factory.prepare(with: context)
        }

        func build(with context: Any?) throws -> UIViewController {
            let viewController = try factory.build(with: context)
            if let context = context {
                try contextTasks.forEach({
                    try $0.apply(on: viewController, with: context)
                })
            }
            postTasks.forEach({
                postTaskRunner?.add(viewController: viewController, postTask: $0)
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

    // this class is just a placeholder. Router needs at least one post-routing task per view controller to
    // store a reference there.
    struct EmptyPostTask: PostRoutingTask {

        func execute(on viewController: UIViewController, with context: Any?, routingStack: [UIViewController]) {
        }

    }

}
