//
// RouteComposer
// Factory.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2021.
// Distributed under the MIT license.
//

#if os(iOS)

import UIKit

/// The `Factory` protocol should be implemented by the instance that produces any types of the view controllers
public protocol Factory: AbstractFactory {

    // MARK: Associated types

    /// Type of `UIViewController` that `Factory` can build
    associatedtype ViewController

    /// `Context` to be passed into `UIViewController`
    associatedtype Context

    // MARK: Methods to implement

    /// Builds a `UIViewController` that will be integrated into the stack
    ///
    /// - Parameter context: A `Context` instance that is provided to the `Router`.
    /// - Returns: The built `UIViewController` instance.
    /// - Throws: The `RoutingError` if build did not succeed.
    func build(with context: Context) throws -> ViewController

}

// MARK: Default implementation

public extension Factory {

    /// Default implementation does nothing
    mutating func prepare(with context: Context) throws {}

}

// MARK: Helper methods

public extension Factory {

    /// Prepares the `Factory` and builds its `UIViewController`
    func execute(with context: Context) throws -> ViewController {
        var factory = self
        try factory.prepare(with: context)
        return try factory.build(with: context)
    }

}

// MARK: Helper methods where the Context is Any?

public extension Factory where Context == Any? {

    /// Builds a `Factory`'s view controller.
    func build() throws -> ViewController {
        try build(with: nil)
    }

    /// Prepares the `Factory` and builds its `UIViewController`
    func execute() throws -> ViewController {
        var factory = self
        try factory.prepare()
        return try factory.build()
    }

}

// MARK: Helper methods where the Context is Void

public extension Factory where Context == Void {

    /// Builds a `Factory`'s view controller.
    func build() throws -> ViewController {
        try build(with: ())
    }

    /// Prepares the `Factory` and builds its `UIViewController`
    func execute() throws -> ViewController {
        var factory = self
        try factory.prepare()
        return try factory.build()
    }

}

#endif
