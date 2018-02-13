//
// Created by Eugene Kazaev on 17/01/2018.
//

import Foundation
import UIKit

/// PostRoutingTask
/// The task to be executed after deep linking happened.
public protocol AnyPostRoutingTask {

    func execute(on viewController: UIViewController, with arguments: Any?, routingStack: [UIViewController])

}

public protocol ConcretePostRoutingTask {

    associatedtype V: UIViewController
    associatedtype A

    func execute(on viewController: V, with arguments: A?, routingStack: [UIViewController])

}

class PostRoutingTaskBox<P: ConcretePostRoutingTask>: AnyPostRoutingTask {

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
