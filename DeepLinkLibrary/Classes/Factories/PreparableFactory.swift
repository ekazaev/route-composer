//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//


import Foundation

/// If factory can tell to router before it will actually start to route to this view controller
/// if it can be build ot not - it should extend this protocol - router will call it before the routing
/// process and if factory is not able to build a view controller (example: it has to build a product view
/// controller but there is no product code in arguments) it can stop router from routing to this destination
/// and the result of routing will be .unhandled without any changes in view controller stack.
public protocol PreparableFactory: Factory {

    func prepare(with arguments: Any?) -> RoutingResult

}
