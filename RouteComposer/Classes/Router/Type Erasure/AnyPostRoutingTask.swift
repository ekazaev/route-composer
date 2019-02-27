//
// Created by Eugene Kazaev on 14/02/2018.
//

import Foundation
import UIKit

protocol AnyPostRoutingTask {

    func execute(on viewController: UIViewController,
                 with context: Any?,
                 routingStack: [UIViewController]) throws

}

struct PostRoutingTaskBox<P: PostRoutingTask>: AnyPostRoutingTask, MainThreadChecking, CustomStringConvertible {

    let postRoutingTask: P

    init(_ postRoutingTask: P) {
        self.postRoutingTask = postRoutingTask
    }

    func execute(on viewController: UIViewController,
                 with context: Any?,
                 routingStack: [UIViewController]) throws {
        guard let typedViewController = viewController as? P.ViewController else {
            throw RoutingError.typeMismatch(P.ViewController.self, .init("\(String(describing: postRoutingTask.self)) does not support" +
                    " \(String(describing: viewController.self))."))
        }
        guard let typedDestination = Any?.some(context as Any) as? P.Context else {
            throw RoutingError.typeMismatch(P.Context.self, .init("\(String(describing: postRoutingTask.self)) does not accept" +
                    "  \(String(describing: context.self)) as a context."))
        }
        assertIfNotMainThread()
        postRoutingTask.execute(on: typedViewController, with: typedDestination, routingStack: routingStack)
    }

    var description: String {
        return String(describing: postRoutingTask)
    }

}
