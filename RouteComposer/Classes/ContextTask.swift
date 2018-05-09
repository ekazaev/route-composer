//
//  ContextTask.swift
//  RouteComposer
//
//  Created by Eugene Kazaev on 27/02/2018.
//

import Foundation
import UIKit

/// ContextTask
/// The task to be executed after `UIViewController` created or found.
public protocol ContextTask {
    
    /// `UIViewController` type associated with this `ContextTask`
    associatedtype ViewController: UIViewController
    
    /// Context type associated with this `ContextTask`
    associatedtype Context

    /// Use this method to inform the `Router` that task can't be applied before it will start actual routing by throwing
    /// RoutingError
    ///
    /// - Parameters:
    ///   - context: The `Context` instance provided to the `Router`
    /// - Throws: The `RoutingError` if `ContextTask` can't be applied.
    func prepare(with context: Context) throws

    /// The method that will be called by the `Router` to run `ContextTask` immediately after `UIViewController` been created
    /// or found
    ///
    /// - Parameters:
    ///   - viewController: The `UIViewController` instance described in the step that `ContextTask` attached to
    ///   - context: The `Context` instance that was passed to the `Router`
    func apply(on viewController: ViewController, with context: Context)
    
}

public extension ContextTask {

    public func prepare(with context: Context) throws {

    }

}
