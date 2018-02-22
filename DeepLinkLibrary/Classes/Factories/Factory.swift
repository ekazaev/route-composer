//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

/// Factory
/// action: router applies action to integrate view controller created by build() in the existing view controller stack
/// build(): builds a view controller that will be pushed to the viw stack
public protocol Factory: class {

    associatedtype V: UIViewController

    associatedtype C

    var action: Action { get }

    /// If factory can tell to router before it will actually start to route to this view controller
    /// if it can be build ot not - it should overload this method - router will call it before the routing
    /// process and if factory is not able to build a view controller (example: it has to build a product view
    /// controller but there is no product code in context) it can stop router from routing to this destination
    /// and the result of routing will be .unhandled without any changes in view controller stack.
    func prepare(with context: C?, logger: Logger?) -> RoutingResult

    func build(logger: Logger?) -> V?

}

public extension Factory {

    func prepare(with context: C?, logger: Logger?) -> RoutingResult {
        return .handled
    }

}
