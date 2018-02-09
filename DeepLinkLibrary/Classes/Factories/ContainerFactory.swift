//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//


import Foundation

/// ContainerFactory protocol should be implemented by Factories that produce any type of the view controllers
/// that can be considered as Containers (eg: UINavigationController, UITabBarController, etc)
///
/// Container apply one merged action and then populate a full stack of view controllers that was built by the associated factories in one go.
/// Example: Steps require to populate n view controllers in UINavigationController stack and it can do so.
/// Merge action implementation is mandatory for any actions and should be implemented if it can be done.
public protocol ContainerFactory {

    /// Receives an array of factories whose view controllers should be merged into current container
    /// factory before it actually builds a container view controller with child view controllers inside.
    /// Example: UINavigationController with N pushed into it UIViewControllers.
    ///
    /// - Parameter factories: Array of factories to be handled by container factory.
    /// - Returns: Array of factories that are not supported by this container type. Router should decide how to deal with them.
    /// Example: UINavigationController as a container expects push action of any kind.
    /// If a factory from factories array contains one with a present modally action, it will be returned back as an unsuppported one.
    func merge(_ factories: [AnyFactory]) -> [AnyFactory]

}

public extension ContainerFactory {

    func filter<T:Action>(_ factories: [AnyFactory], accept: [T.Type]) -> (accepted: [AnyFactory], rest: [AnyFactory]) {
        var rest: [AnyFactory] = []
        let inFactories = factories.filter { factory in
            guard accept.contains(where: { type(of: factory.action) == $0  }) else {
                rest.append(factory)
                return false
            }
            return true
        }

        return (accepted: inFactories, rest: rest)
    }

}