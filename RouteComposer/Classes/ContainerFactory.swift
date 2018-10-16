//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit

/// The `ContainerFactory` protocol should be implemented by the instance that produces any types of the view controllers
/// that can be considered as containers (eg: `UINavigationController`, `UITabBarController`, etc)
///
/// The `Router` uses `perform(embedding:)` method of a `ContainerAction` and then populates a full stack of the view controllers
/// that were built by the associated factories in one go.
/// Example: `Router` requires to populate N-view controllers into `UINavigationController`'s stack.
public protocol ContainerFactory: AbstractFactory {

    /// Type of the `UIViewController` that `ContainerFactory` can build. Must be a `ContainerViewController`.
    associatedtype ViewController = ViewController where ViewController: ContainerViewController

    /// Type of context `Context` instance that `ContainerFactory` needs
    associatedtype Context = Context

    /// Builds a `UIViewController` that will be integrated into the stack
    ///
    /// Parameters:
    ///   - context: A `Context` instance that is provided to the `Router`.
    ///   - coordinator: A `ChildCoordinator` instance.
    /// - Returns: The built `UIViewController` instance with the children view controller inside.
    /// - Throws: The `RoutingError` if build did not succeed.
    func build(with context: Context, integrating coordinator: ChildCoordinator<Context>) throws -> ViewController

}

public extension ContainerFactory {

    /// Default implementation does nothing
    mutating func prepare(with context: Context) throws {
    }

    /// Builds a `ContainerFactory` view controller.
    func build(with context: Context) throws -> ViewController {
        return try build(with: context, integrating: ChildCoordinator(childFactories: []))
    }

}

public extension ContainerFactory where Context == Any? {

    /// Builds a `ContainerFactory` view controller.
    func build() throws -> ViewController {
        return try build(with: nil, integrating: ChildCoordinator(childFactories: []))
    }

}
