//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation

/// Router will use assembly provided by a destination as a starting point to build steps for routing to it.
public protocol RoutingDestination {

    /// Routing step instance that represents end point of routing.
    var finalStep: RoutingStep { get }

    /// Context object to be passed to any UIViewController to be build or presented.
    var context: Any? { get }

}
