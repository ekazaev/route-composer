//
// Created by Eugene Kazaev on 14/02/2018.
//

import Foundation
import UIKit

/// Non type safe boxing wrapper for PostRoutingTask protocol
protocol AnyPostRoutingTask {

    func execute(on viewController: UIViewController,
                 for context: Any?,
                 routingStack: [UIViewController]) throws

}

struct PostRoutingTaskBox<P: PostRoutingTask>: AnyPostRoutingTask, CustomStringConvertible {

    let postRoutingTask: P

    init(_ postRoutingTask: P) {
        self.postRoutingTask = postRoutingTask
    }

    func execute(on viewController: UIViewController,
                 for context: Any?,
                 routingStack: [UIViewController]) throws {
        guard let typedViewController = viewController as? P.ViewController,
              let typedDestination = Any?.some(context as Any) as? P.Context else {
            throw RoutingError.message("\(String(describing: postRoutingTask)) does not support" +
                    " \(String(describing: viewController)) or \(String(describing: context))")
        }
        postRoutingTask.execute(on: typedViewController, for: typedDestination, routingStack: routingStack)
    }

    var description: String {
        return String(describing: postRoutingTask)
    }

}
