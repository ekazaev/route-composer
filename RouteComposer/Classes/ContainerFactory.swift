//
// RouteComposer
// ContainerFactory.swift
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

/// The `ContainerFactory` protocol should be implemented by the instance that produces any types of the view controllers
/// that can be considered as containers (eg: `UINavigationController`, `UITabBarController`, etc)
///
/// The `Router` uses `ContainerAction.perform(...)` method of a `ContainerAction` and then populates a full stack of the view controllers
/// that were built by the associated factories in one go.
/// Example: `Router` requires to populate N-view controllers into `UINavigationController`'s stack.
public protocol ContainerFactory: AbstractFactory where ViewController: ContainerViewController {

    // MARK: Associated types

    /// Type of `UIViewController` that `ContainerFactory` can build
    associatedtype ViewController

    /// `Context` to be passed into `UIViewController`
    associatedtype Context

    // MARK: Methods to implement

    /// Builds a `UIViewController` that will be integrated into the stack
    ///
    /// Parameters:
    ///   - context: A `Context` instance that is provided to the `Router`.
    ///   - coordinator: A `ChildCoordinator` instance.
    /// - Returns: The built `UIViewController` instance with the children view controller inside.
    /// - Throws: The `RoutingError` if build did not succeed.
    func build(with context: Context, integrating coordinator: ChildCoordinator) throws -> ViewController

}

// MARK: Default implementation

public extension ContainerFactory {

    /// Default implementation does nothing
    mutating func prepare(with context: Context) throws {}

}

// MARK: Helper methods

public extension ContainerFactory {

    /// Builds a `ContainerFactory` view controller.
    func build(with context: Context) throws -> ViewController {
        try build(with: context, integrating: ChildCoordinator(childFactories: []))
    }

    /// Prepares the `Factory` and builds its `UIViewController`
    func execute(with context: Context) throws -> ViewController {
        var factory = self
        try factory.prepare(with: context)
        return try factory.build(with: context)
    }

}

// MARK: Helper methods where the Context is Any?

public extension ContainerFactory where Context == Any? {

    /// Builds a `ContainerFactory` view controller.
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

public extension ContainerFactory where Context == Void {

    /// Builds a `ContainerFactory` view controller.
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
