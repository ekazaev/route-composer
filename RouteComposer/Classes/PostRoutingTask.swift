//
// Created by Eugene Kazaev on 17/01/2018.
//

import Foundation
import UIKit

/// The task to be executed after navigation process happened.
public protocol PostRoutingTask {

    // MARK: Associated types

    /// `UIViewController` type associated with this `PostRoutingTask`
    associatedtype ViewController: UIViewController

    /// `Context` type associated with this `PostRoutingTask`
    associatedtype Context

    // MARK: Methods to implement

    /// Method to be executed by the `Router` after all the view controllers have been built into the stack.
    ///
    /// - Parameters:
    ///   - viewController: The `UIViewController` instance that this post-task has been attached to
    ///   - context: The `Context` instance provided to the `Router`
    ///   - routingStack: An array of all the view controllers that been built by the `Router` to
    ///     reach the final destination
    func perform(on viewController: ViewController, with context: Context, routingStack: [UIViewController])

}

// MARK: Helper methods where the Context is Any?

public extension PostRoutingTask where Context == Any? {

    /// Method to be executed by the `Router` after all the view controllers have been built into the stack.
    ///
    /// - Parameters:
    ///   - viewController: The `UIViewController` instance that this post-task has been attached to
    ///   - routingStack: An array of all the view controllers that been built by the `Router` to
    ///     reach the final destination
    func perform(on viewController: ViewController, routingStack: [UIViewController]) {
        perform(on: viewController, with: nil, routingStack: routingStack)
    }

}

// MARK: Helper methods where the Context is Void

public extension PostRoutingTask where Context == Void {

    /// Method to be executed by the `Router` after all the view controllers have been built into the stack.
    ///
    /// - Parameters:
    ///   - viewController: The `UIViewController` instance that this post-task has been attached to
    ///   - routingStack: An array of all the view controllers that been built by the `Router` to
    ///     reach the final destination
    func perform(on viewController: ViewController, routingStack: [UIViewController]) {
        perform(on: viewController, with: (), routingStack: routingStack)
    }

}
