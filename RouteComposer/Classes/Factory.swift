//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright © 2018 HBC Digital. All rights reserved.
//

import UIKit

/// The `Factory` protocol should be implemented by the instance that produces any types of the view controllers
public protocol Factory: AbstractFactory {

    /// Type of the `UIViewController` that `Factory` can build
    associatedtype ViewController = ViewController

    /// Type of `Context` instance that `Factory` needs to build it's `UIViewController`
    associatedtype Context = Context

    /// Builds a `UIViewController` that will be integrated into the stack
    ///
    /// - Parameter context: A `Context` instance that is provided to the `Router`.
    /// - Returns: The built `UIViewController` instance.
    /// - Throws: The `RoutingError` if build did not succeed.
    func build(with context: Context) throws -> ViewController

}

/// Default implementation
public extension Factory {

    /// Default implementation does nothing
    mutating func prepare(with context: Context) throws {
    }

    /// Prepares the `Factory` and builds a `UIViewController`
    func buildPrepared(with context: Context) throws -> ViewController {
        var factory = self
        try factory.prepare(with: context)
        return try factory.build(with: context)
    }

}

/// Default implementation for any context
public extension Factory where Context == Any? {

    /// Builds a `Factory`'s view controller.
    func build() throws -> ViewController {
        return try build(with: nil)
    }

    /// Prepares the `Factory` and builds a `UIViewController`
    func buildPrepared() throws -> ViewController {
        var factory = self
        try factory.prepare()
        return try factory.build()
    }

}
