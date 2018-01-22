//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

/// Factory's only responcibility is to  build a UIViewController on routers demand and then router uses a
///factory action to integrate UIViewController that has been built by a factory in to existant view controller stack
public protocol Factory: class {

    var action: ViewControllerAction? { get }

    func build(with logger: Logger?) -> UIViewController?

}


/// If factory can tell to router before it will actually start to route to this view controller
/// if it can be build ot not - it should extend this protocol - router will call it before the routing
/// process and if factory is not able to build a view controller (example: it has to build a product view
/// controller but there is no product code in arguments) it can stop router from routing to this destination
/// and result of routing will be .unhandled without any changes in view controller stack.
public protocol PreparableFactory: Factory {

    func prepare(with arguments: Any?) -> DeepLinkResult

}

/// ContainerFactory protocol should be extended by Factories that produces any type of view controllers
/// that can be considered as Contaners (eg: UINavigationController, UITabBarController e.t.c) that want to
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
