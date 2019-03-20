//
// Created by Eugene Kazaev on 17/01/2018.
//

import Foundation
import UIKit

/// The task to be executed after navigation process happened.
public protocol PostRoutingTask {

    /// `UIViewController` type associated with this `PostRoutingTask`
    associatedtype ViewController: UIViewController

    /// `Context` type associated with this `PostRoutingTask`
    associatedtype Context

    /// Method to be executed by the `Router` after all the view controllers have been built into the stack.
    ///
    /// - Parameters:
    ///   - viewController: The `UIViewController` instance that this post-task has been attached to
    ///   - context: The `Context` instance provided to the `Router`
    ///   - routingStack: An array of all the view controllers that been built by the `Router` to
    ///     reach the final destination
    func execute(on viewController: ViewController, with context: Context, routingStack: [UIViewController])

}

public extension PostRoutingTask where Context == Any? {

    /// Method to be executed by the `Router` after all the view controllers have been built into the stack.
    ///
    /// - Parameters:
    ///   - viewController: The `UIViewController` instance that this post-task has been attached to
    ///   - routingStack: An array of all the view controllers that been built by the `Router` to
    ///     reach the final destination
    func execute(on viewController: ViewController, routingStack: [UIViewController]) {
        execute(on: viewController, with: nil, routingStack: routingStack)
    }

}

public extension PostRoutingTask where Context == Void {

    /// Method to be executed by the `Router` after all the view controllers have been built into the stack.
    ///
    /// - Parameters:
    ///   - viewController: The `UIViewController` instance that this post-task has been attached to
    ///   - routingStack: An array of all the view controllers that been built by the `Router` to
    ///     reach the final destination
    func execute(on viewController: ViewController, routingStack: [UIViewController]) {
        execute(on: viewController, with: (), routingStack: routingStack)
    }

}
