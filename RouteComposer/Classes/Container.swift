//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit

/// The `Container` protocol should be implemented by the instance that produces any types of the view controllers
/// that can be considered as containers (eg: `UINavigationController`, `UITabBarController`, etc)
///
/// The `Container` uses `perform(embedding:)` method of an `Action` and then populate a full stack of the view controllers
/// that was built by the associated factories in one go.
/// Example: Steps requires to populate N-view controllers in `UINavigationController` stack and it can do so.
/// `merge` method implementation is mandatory.
public protocol Container: AbstractFactory {

    /// Type of the `UIViewController` that `Container` can build
    associatedtype ViewController = ViewController

    /// Type of context `Context` instance that `Container` needs
    associatedtype Context = Context

    /// Type of supported `Action` instances
    associatedtype SupportedAction

    /// Builds a `UIViewController` that will be integrated into the stack
    ///
    /// Parameters:
    ///   - context: A `Context` instance if it was provided to the `Router`.
    ///   - factories: `ChildFactory` instances that will build children view controllers when requested.
    /// - Returns: The built `UIViewController` instance.
    /// - Throws: The `RoutingError` if build was not succeed.
    func build(with context: Context, integrating factories: [ChildFactory<Context>]) throws -> ViewController

}

public extension Container {

    /// Default implementation does nothnig
    mutating func prepare(with context: Context) throws {
    }

}

/// - `Container` `Factory` extension that helps to build properly child `UIViewController`s from factories provided.
public extension Container {

    /// This function contains default implementation how Container should create its children view controller
    /// before built them into itself.
    ///
    /// - Parameters:
    ///   - factories: An array of `ChildFactory` instances
    ///   - context: A `Context` instance to be used to build the children view controllers
    /// - Returns: An array of build view controllers
    /// - Throws: RoutingError
    public func buildChildrenViewControllers(from factories: [ChildFactory<Context>], with context: Context) throws -> [UIViewController] {
        var childrenViewControllers: [UIViewController] = []
        for factory in factories {
            try factory.build(with: context, in: &childrenViewControllers)
        }
        return childrenViewControllers
    }

}
