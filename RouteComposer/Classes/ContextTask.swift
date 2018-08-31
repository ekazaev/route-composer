//
//  ContextTask.swift
//  RouteComposer
//
//  Created by Eugene Kazaev on 27/02/2018.
//

import Foundation
import UIKit

/// The task to be executed after a `UIViewController` was created or found.
public protocol ContextTask {

    /// A`UIViewController` type associated with this `ContextTask`
    associatedtype ViewController: UIViewController

    /// A Context type associated with this `ContextTask`
    associatedtype Context

    /// If the `ContextTask` can tell the `Router` if it can be applied a `UIViewController` or not - it should implement this method.
    /// The `Router` will call it before the routing process and if the `ContextTask` is not able to
    /// be applied a view controller it should throw an exception.
    ///
    /// - Parameters:
    ///   - context: The `Context` instance provided to the `Router`
    /// - Throws: The `RoutingError` if `ContextTask` can't be applied.
    mutating func prepare(with context: Context) throws

    /// The method that will be called by the `Router` to run `ContextTask` immediately after `UIViewController` been created
    /// or found
    ///
    /// - Parameters:
    ///   - viewController: The `UIViewController` instance described in the step that `ContextTask` attached to
    ///   - context: The `Context` instance that was passed to the `Router`
    func apply(on viewController: ViewController, with context: Context) throws

}

public extension ContextTask {

    public mutating func prepare(with context: Context) throws {

    }

}
