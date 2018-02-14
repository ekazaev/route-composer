//
// Created by Eugene Kazaev on 14/02/2018.
//

import Foundation
import UIKit

protocol AnyPostRoutingTask {

    func execute(on viewController: UIViewController, with arguments: Any?, routingStack: [UIViewController])

}

class PostRoutingTaskBox<P: PostRoutingTask>: AnyPostRoutingTask {

    let postRoutingTask: P

    init(_ postRoutingTask: P) {
        self.postRoutingTask = postRoutingTask
    }

    func execute(on viewController: UIViewController, with arguments: Any?, routingStack: [UIViewController]) {
        guard let typedViewController = viewController as? P.V,
              let typedArguments = arguments as? P.A? else {
            print("\(String(describing:postRoutingTask)) does not accept \(String(describing: viewController)) and \(String(describing: arguments)) as a parameters.")
            return
        }
        postRoutingTask.execute(on: typedViewController, with: typedArguments, routingStack: routingStack)
    }

}