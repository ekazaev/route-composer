//
// Created by Eugene Kazaev on 14/02/2018.
//

import Foundation
import UIKit

/// Non type safe boxing wrapper for PostRoutingTask protocol
protocol AnyPostRoutingTask {

    func execute<D: RoutingDestination>(on viewController: UIViewController, for destination: D, routingStack: [UIViewController]) throws

}

class PostRoutingTaskBox<P: PostRoutingTask>: AnyPostRoutingTask, CustomStringConvertible {

    let postRoutingTask: P

    init(_ postRoutingTask: P) {
        self.postRoutingTask = postRoutingTask
    }

    func execute<D: RoutingDestination>(on viewController: UIViewController, for destination: D, routingStack: [UIViewController]) throws {
        guard let typedViewController = viewController as? P.ViewController,
              let typedDestination = destination as? P.Destination else {
            throw RoutingError.message("\(String(describing: postRoutingTask)) does not support \(String(describing: viewController)) or \(String(describing: destination))")
        }
        postRoutingTask.execute(on: typedViewController, for: typedDestination, routingStack: routingStack)
    }

    var description: String {
        return String(describing: postRoutingTask)
    }

}
