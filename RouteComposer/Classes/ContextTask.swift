//
// RouteComposer
// ContextTask.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import UIKit

/// The task to be applied after a `UIViewController` was created or found.
///
/// ### NB
/// The `ContextTask` will be applied to the new `UIViewController` before it's integration into the stack.
public protocol ContextTask {

    // MARK: Associated types

    /// A`UIViewController` type associated with this `ContextTask`
    associatedtype ViewController: UIViewController

    /// A Context type associated with this `ContextTask`
    associatedtype Context

    // MARK: Methods to implement

    /// The `Router` will call this method before the navigation process. If the `ContextTask` is not able to
    /// be applied to a view controller it should throw an exception.
    ///
    /// - Parameters:
    ///   - context: The `Context` instance provided to the `Router`
    /// - Throws: The `RoutingError` if `ContextTask` can't be applied.
    mutating func prepare(with context: Context) throws

    /// The `Router` will call this method to run the `ContextTask` immediately after `UIViewController` been created
    /// or found
    ///
    /// - Parameters:
    ///   - viewController: The `UIViewController` instance described in the step that `ContextTask` attached to
    ///   - context: The `Context` instance that was passed to the `Router`
    func perform(on viewController: ViewController, with context: Context) throws

}

// MARK: Default implementation

public extension ContextTask {

    /// Default implementation does nothing
    mutating func prepare(with context: Context) throws {}

}

// MARK: Helper methods

public extension ContextTask {

    /// Prepares the `ContextTask` and executes it
    func execute(on viewController: ViewController, with context: Context) throws {
        var contextTask = self
        try contextTask.prepare(with: context)
        try contextTask.perform(on: viewController, with: context)
    }

}

// MARK: Helper methods where the Context is Any?

public extension ContextTask where Context == Any? {

    /// The `Router` will call this method before the navigation process. If the `ContextTask` is not able to
    /// be applied to a view controller it should throw an exception.
    ///
    /// - Throws: The `RoutingError` if `ContextTask` can't be applied.
    mutating func prepare() throws {
        try prepare(with: nil)
    }

    /// The `Router` will call this method to run the `ContextTask` immediately after `UIViewController` been created
    /// or found
    ///
    /// - Parameters:
    ///   - viewController: The `UIViewController` instance described in the step that `ContextTask` attached to
    func perform(on viewController: ViewController) throws {
        try perform(on: viewController, with: nil)
    }

    /// Prepares the `ContextTask` and executes it
    func execute(on viewController: ViewController) throws {
        try execute(on: viewController, with: nil)
    }

}

// MARK: Helper methods where the Context is Void

public extension ContextTask where Context == Void {

    /// The `Router` will call this method before the navigation process. If the `ContextTask` is not able to
    /// be applied to a view controller it should throw an exception.
    ///
    /// - Throws: The `RoutingError` if `ContextTask` can't be applied.
    mutating func prepare() throws {
        try prepare(with: ())
    }

    /// The method that will be called by the `Router` to run `ContextTask` immediately after `UIViewController` been created
    /// or found
    ///
    /// - Parameters:
    ///   - viewController: The `UIViewController` instance described in the step that `ContextTask` attached to
    func perform(on viewController: ViewController) throws {
        try perform(on: viewController, with: ())
    }

    /// Prepares the `ContextTask` and executes it
    func execute(on viewController: ViewController) throws {
        try execute(on: viewController, with: ())
    }

}
