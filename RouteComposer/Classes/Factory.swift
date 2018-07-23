//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import UIKit

/// An instance that extends `Factory` builds `UIViewController` that will be later integrated into the stack by `Router`
public protocol Factory {

    /// Type of `UIViewController` that `Factory` can build
    associatedtype ViewController: UIViewController

    /// `Context` to be passed into `UIViewController`
    associatedtype Context

    /// `Action` instance. The `Router` applies `Action` to integrate view controller created by `build(with:)` in the existing
    /// view controller stack
    var action: Action { get }

    /// If the `Factory` can tell the `Router` if it can be built or not - it should overload this method.
    /// `Router` will call it before the routing process and if `Factory` is not able to
    /// build a view controller (example: it has to build a product view
    /// controller but there is no product code in context) it can stop `Router` from routing to this destination
    /// and the result of routing will be `.unhandled` without any changes in view controller stack.
    ///
    /// - Parameter context: The `Context` instance if it was provided to the `Router`.
    /// - Throws: The `RoutingError` if the `Factory` can not prepare itself to build a `UIViewController` instance
    ///   with the `Context` instance provided.
    mutating func prepare(with context: Context) throws

    /// Builds a `UIViewController` that will be built into the stack
    ///
    /// - Parameter context: A `Context` instance if it was provided to the `Router`.
    /// - Returns: The built `UIViewController` instance.
    /// - Throws: The `RoutingError` if build was not succeed.
    func build(with context: Context) throws -> ViewController

}

public extension Factory {

    func prepare(with context: Context) throws {
    }

}
