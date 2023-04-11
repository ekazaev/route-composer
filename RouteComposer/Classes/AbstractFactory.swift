//
// RouteComposer
// AbstractFactory.swift
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

/// Base protocol for all types of factories.
/// An instance that extends `AbstractFactory` builds a `UIViewController` that will later be
/// integrated into the stack by the `Router`
public protocol AbstractFactory {

    // MARK: Associated types

    /// Type of `UIViewController` that `AbstractFactory` can build
    associatedtype ViewController: UIViewController

    /// `Context` to be passed into `UIViewController`
    associatedtype Context

    // MARK: Methods to implement

    /// The `Router` will call it before the navigation process and if the `AbstractFactory` is not able to
    /// build a view controller it should throw an exception. (example: it has to build a product view
    //  controller but there is no product code in context)
    ///
    /// - Parameter context: A `Context` instance that is provided to the `Router`.
    /// - Throws: The `RoutingError` if the `Factory` cannot prepare to build a `UIViewController` instance
    ///   with the `Context` instance provided.
    mutating func prepare(with context: Context) throws

}

// MARK: Helper methods where the Context is Any?

public extension AbstractFactory where Context == Any? {

    /// Prepares the `AbstractFactory`
    mutating func prepare() throws {
        try prepare(with: nil)
    }

}

// MARK: Helper methods where the Context is Void

public extension AbstractFactory where Context == Void {

    /// Prepares the `AbstractFactory`
    mutating func prepare() throws {
        try prepare(with: ())
    }

}
