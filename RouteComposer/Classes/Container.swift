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

    /// Receives an array of child factories whose view controllers should be integrated into a current `Container`
    /// before it actually builds a its view controller.
    /// Example: The `UINavigationController` instance with N `UIViewController`s pushed into it.
    ///
    /// - Parameter factories: An array of child factories to be handled by `Container` `Factory`.
    /// - Returns: An array of factories that are not supported by this container type.
    ///   `Router` will decide how to deal with them.
    ///
    /// Example: The `NavigationControllerFactory` will return all the ChildFactory with non `NavigationControllerFactory`'a actions inside.
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
    public func buildChildrenViewControllers(from factories: [ChildFactory<Context>], with context: Context) throws -> [UIViewController] {
        var childrenViewControllers: [UIViewController] = []
        for factory in factories {
            try factory.build(with: context, in: &childrenViewControllers)
        }
        return childrenViewControllers
    }

}
