//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit

/// `Container` protocol should be implemented by the `Factory`s that produce any type of the view controllers
/// that can be considered as containers (eg: UINavigationController, UITabBarController, etc)
///
/// `Container` applies one merged `Action` and then populate a full stack of view controllers
/// that was built by the associated factories in one go.
/// Example: Steps requires to populate N-view controllers in `UINavigationController` stack and it can do so.
/// `merge` method implementation is mandatory.
public protocol Container: AbstractFactory {

    /// Receives an array of factories whose view controllers should be merged into current container
    /// `Factory` before it actually builds a container view controller with child view controllers inside.
    /// Example: The `UINavigationController` instance with N pushed into it `UIViewController`s.
    ///
    /// - Parameter factories: An array of factories to be handled by `Container` `Factory`.
    /// - Returns: An array of factories that are not supported by this container type.
    ///   `Router` will decide how to deal with them.
    ///
    /// Example: The `UINavigationController` instance as a container expects to push `Action` of any kind.
    /// If a `ChildFactory` from factories array contains one with a present modally action, it will be returned
    /// back to an unsupported one.
    mutating func merge(_ factories: [ChildFactory<Context>]) -> [ChildFactory<Context>]

}

/// - `Container` `Factory` extension that helps to build properly child `UIViewController`s from factories provided.
public extension Container {

    /// This function contains default implementation how Container should create its children view controller
    /// before built them into itself.
    ///
    /// - Parameters:
    ///   - factories: An array of child factories
    ///   - context: A `Context` instance if any
    /// - Returns: An array of build view controllers
    /// - Throws: RoutingError
    public func buildChildrenViewControllers(from factories: [ChildFactory<Self.Context>], with context: Self.Context) throws -> [UIViewController] {
        var childrenViewControllers: [UIViewController] = []
        for factory in factories {
            try factory.build(with: context, in: &childrenViewControllers)
        }
        return childrenViewControllers
    }

}
