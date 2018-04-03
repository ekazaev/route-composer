//
// Created by Eugene Kazaev on 17/01/2018.
//

import Foundation
import UIKit

/// The task to be executed after deep linking happened.
public protocol PostRoutingTask {

    associatedtype ViewController: UIViewController

    associatedtype Destination: RoutingDestination

    /// Method to be executed by `Router` after all the view controller has been build in to stack.
    ///
    /// - Parameters:
    ///   - viewController: The `UIViewController` instance that this post task has been attached to
    ///   - destination: The `RoutingDestination` instance provided to the `Router`
    ///   - routingStack: An array of all the view controllers that been built by the `Router` to
    ///     reach a final destination
    func execute(on viewController: ViewController, for destination: Destination, routingStack: [UIViewController])

}
