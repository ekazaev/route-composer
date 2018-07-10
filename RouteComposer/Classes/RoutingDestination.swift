//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation

/// The `Router` will use `RoutingStep` instance provided by a `RoutingDestination` as a starting point
/// to build steps for routing to it.
public protocol RoutingDestination {

    /// Context type associated with the `RoutingDestination` instance.
    associatedtype Context

    /// A `RoutingStep` instance that represents the end point of routing.
    var finalStep: RoutingStep { get }

    /// A `Context` instance to be passed to any `UIViewController` to be build or presented.
    var context: Context { get }

}
