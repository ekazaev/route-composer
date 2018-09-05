//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import UIKit

/// An instance that extends `Factory` builds a `UIViewController` that will be later integrated
/// into the stack by the `Router`
public protocol Factory: AbstractFactory {

    /// Type of the `UIViewController` that `Factory` can build
    associatedtype ViewController = ViewController

    /// Type of context `Context` instance that `Factory` needs
    associatedtype Context = Context

    /// Builds a `UIViewController` that will be integrated into the stack
    ///
    /// - Parameter context: A `Context` instance if it was provided to the `Router`.
    /// - Returns: The built `UIViewController` instance.
    /// - Throws: The `RoutingError` if build was not succeed.
    func build(with context: Context) throws -> ViewController

}

public extension Factory {

    /// Default implementation does nothnig
    mutating func prepare(with context: Context) throws {
    }

}
