//
// Created by Eugene Kazaev on 2019-02-27.
//

import Foundation

struct PostRoutingTaskBox<PT: PostRoutingTask>: AnyPostRoutingTask, MainThreadChecking, CustomStringConvertible {

    let postRoutingTask: PT

    init(_ postRoutingTask: PT) {
        self.postRoutingTask = postRoutingTask
    }

    func execute<Context>(on viewController: UIViewController,
                          with context: Context,
                          routingStack: [UIViewController]) throws {
        guard let typedViewController = viewController as? PT.ViewController else {
            throw RoutingError.typeMismatch(PT.ViewController.self, .init("\(String(describing: postRoutingTask.self)) does not support" +
                    " \(String(describing: viewController.self))."))
        }
        guard let typedDestination = Any?.some(context as Any) as? PT.Context else {
            throw RoutingError.typeMismatch(PT.Context.self, .init("\(String(describing: postRoutingTask.self)) does not accept" +
                    "  \(String(describing: context.self)) as a context."))
        }
        assertIfNotMainThread()
        postRoutingTask.execute(on: typedViewController, with: typedDestination, routingStack: routingStack)
    }

    var description: String {
        return String(describing: postRoutingTask)
    }

}
