//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//


import Foundation

/// ContainerFactory protocol should be extended by Factories that produces any type of view controllers
/// that can be considered as Containers (eg: UINavigationController, UITabBarController e.t.c) that want to
/// apply one merged actions and then populate a full stack of view controllers that were build by factories
/// in one go. Example: Steps require to populate n view controllers in UINavigationController stack and it can do so.
/// Merge action implementation is mandatory for any actions and should be implemented if it can be done.
public protocol ContainerFactory: Factory {

    /// Receives an array of fabrics whis view controllers should be merged in to implementing container
    /// factory before it actually build container UIViewController with a children inside.
    /// Example: UINavvigationController with N pushed in to it UIViewControllers.
    ///
    /// - Parameter screenFactories: Array of factories that were are sits in router to be handled by any container.
    /// - Returns: Array of factories that are not supported by this container type. Router should decide how to deal
    /// with them. Example: Fabrics that have to be pushed in a UINavigationController by a push action, but it cant
    /// deal with action that asks to present UIViewController modally. That view controller has to be returned back.
    func merge(_ screenFactories: [Factory]) -> [Factory]

}