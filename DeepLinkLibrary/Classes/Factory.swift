//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

/// Instance that extends Factory builds UIViewController that will be later integrated in to stack by Router
public protocol Factory: class {

    /// Type of UIViewController that Factory can build
    associatedtype ViewController: UIViewController

    /// Context to be passed to UIViewController
    associatedtype Context

    /// Action instance. Router applies action to integrate view controller created by build() in the existing
    /// view controller stack
    var action: Action { get }

    /// If factory can tell to router before it will actually start to route to this view controller
    /// if it can be build ot not - it should overload this method - router will call it before the routing
    /// process and if factory is not able to build a view controller (example: it has to build a product view
    /// controller but there is no product code in context) it can stop router from routing to this destination
    /// and the result of routing will be .unhandled without any changes in view controller stack.
    ///
    /// - Parameter context: Context instance if it was provided to the Router.
    /// - Throws: RoutingException if factry can not prepare itself to build a view controller with context provided.
    func prepare(with context: Context?) throws

    /// Builds a UIViewController that will be built in to the stack
    ///
    /// - Parameter context: Context instance if it was provided to the Router.
    /// - Returns: Built UIViewController instance.
    /// - Throws: RoutingException if build was not succeed.
    func build(with context: Context?) throws -> ViewController

}

public extension Factory {

    func prepare(with context: Context?) throws {
    }

}
