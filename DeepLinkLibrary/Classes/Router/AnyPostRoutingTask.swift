//
// Created by Eugene Kazaev on 14/02/2018.
//

import Foundation
import UIKit

/// Non typesafe boxing wrapper for PostRoutingTask protocol
protocol AnyPostRoutingTask {

    func execute(on viewController: UIViewController, with context: Any?, routingStack: [UIViewController])

}

class PostRoutingTaskBox<P: PostRoutingTask>: AnyPostRoutingTask, CustomStringConvertible {

    let postRoutingTask: P

    init(_ postRoutingTask: P) {
        self.postRoutingTask = postRoutingTask
    }

    func execute(on viewController: UIViewController, with context: Any?, routingStack: [UIViewController]) {
        guard let typedViewController = viewController as? P.ViewController,
              let typedContext = context as? P.Context? else {
            print("\(String(describing:postRoutingTask)) does not accept \(String(describing: viewController)) and \(String(describing: context)) as a context.")
            return
        }
        postRoutingTask.execute(on: typedViewController, with: typedContext, routingStack: routingStack)
    }

    var description: String {
        return String(describing: postRoutingTask)
    }

}
