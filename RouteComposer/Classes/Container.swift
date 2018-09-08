//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit

/// The `Container` protocol should be implemented by the instance that produces any types of the view controllers
/// that can be considered as containers (eg: `UINavigationController`, `UITabBarController`, etc)
///
/// The `Container` uses `perform(embedding:)` method of an `ContainerAction` and then populate a full stack of the view controllers
/// that was built by the associated factories in one go.
/// Example: `Router` requires to populate N-view controllers into `UINavigationController`'s stack and it can do so.
public protocol Container: AbstractFactory {

    /// Type of the `UIViewController` that `Container` can build. Must be a `ContainerViewController`.
    associatedtype ViewController = ViewController where ViewController: ContainerViewController

    /// Type of context `Context` instance that `Container` needs
    associatedtype Context = Context

    /// Builds a `UIViewController` that will be integrated into the stack
    ///
    /// Parameters:
    ///   - context: A `Context` instance if it was provided to the `Router`.
    ///   - coordinator: A `ChildCoordinator` instance.
    /// - Returns: The built `UIViewController` instance with children inside.
    /// - Throws: The `RoutingError` if build was not succeed.
    func build(with context: Context, integrating coordinator: ChildCoordinator<Context>) throws -> ViewController

}

public extension Container {

    /// Builds a `Container` container view controller. Use this function if you want to build your `Container` programmatically.
    func build(with context: Context) throws -> ViewController {
        return try build(with: context, integrating: ChildCoordinator(childFactories: []))
    }

}

public extension Container where Context == Any? {

    /// Builds a `Container` container view controller. Use this function if you want to build your `Container` programmatically.
    func build() throws -> ViewController {
        return try build(with: nil, integrating: ChildCoordinator(childFactories: []))
    }

}

public extension Container {

    /// Default implementation does nothing
    mutating func prepare(with context: Context) throws {
    }

}
