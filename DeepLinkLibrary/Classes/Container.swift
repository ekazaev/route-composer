//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//


import Foundation
import UIKit

/// Container protocol should be implemented by Factories that produce any type of the view controllers
/// that can be considered as Containers (eg: UINavigationController, UITabBarController, etc)
///
/// Container apply one merged action and then populate a full stack of view controllers that was built by the associated factories in one go.
/// Example: Steps require to populate n view controllers in UINavigationController stack and it can do so.
/// Merge action implementation is mandatory for any actions and should be implemented if it can be done.
public protocol Container {

    /// Receives an array of factories whose view controllers should be merged into current container
    /// factory before it actually builds a container view controller with child view controllers inside.
    /// Example: UINavigationController with N pushed into it UIViewControllers.
    ///
    /// - Parameter factories: Array of factories to be handled by container factory.
    /// - Returns: Array of factories that are not supported by this container type. Router should decide how to deal with them.
    ///
    /// Example: UINavigationController as a container expects push action of any kind.
    /// If a factory from factories array contains one with a present modally action, it will be returned
    /// back as an unsupported one.
    func merge<C>(_ factories: [ChildFactory<C>]) -> [ChildFactory<C>]

}

/// - Container Factory extension that helps to build properly child UIViewControllers from factories provided.
public extension Container where Self: Factory {

    /// This function contains default implementation how Container should create it's children view controller
    /// before built them in to itself.
    ///
    /// - Parameters:
    ///   - factories: Array of child factories
    ///   - context: Context instance if any
    /// - Returns: Array of build view controllers
    /// - Throws: RoutingError
    func buildChildrenViewControllers(from factories: [ChildFactory<Self.Context>], with context: Self.Context?) throws -> [UIViewController] {
        var childrenViewControllers: [UIViewController] = []
        for factory in factories {
            try factory.build(with: context, in: &childrenViewControllers)
        }
        return  childrenViewControllers
    }

}