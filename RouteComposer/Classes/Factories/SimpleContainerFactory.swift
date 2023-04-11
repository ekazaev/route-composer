//
// RouteComposer
// SimpleContainerFactory.swift
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

/// A helper protocol to the `ContainerFactory` protocol. If a container does not need to deal with the children view
/// controller creation, `SimpleContainerFactory` will handle integration of the children view controllers.
public protocol SimpleContainerFactory: ContainerFactory {

    // MARK: Associated types

    /// Type of `UIViewController` that `SimpleContainerFactory` can build
    associatedtype ViewController

    /// `Context` to be passed into `UIViewController`
    associatedtype Context

    // MARK: Methods to implement

    /// Builds a `UIViewController` that will be integrated into the stack
    ///
    /// Parameters:
    ///   - context: A `Context` instance provided to the `Router`.
    ///   - viewControllers: `UIViewController` instances to be integrated into the container as children view controllers
    /// - Returns: The built `UIViewController` container instance.
    /// - Throws: The `RoutingError` if the build does not succeed.
    func build(with context: Context, integrating viewControllers: [UIViewController]) throws -> ViewController

}

public extension SimpleContainerFactory {

    /// Default implementation of the `ContainerFactory`'s `build` method
    func build(with context: Context, integrating coordinator: ChildCoordinator) throws -> ViewController {
        let viewControllers = try coordinator.build()
        return try build(with: context, integrating: viewControllers)
    }

}
