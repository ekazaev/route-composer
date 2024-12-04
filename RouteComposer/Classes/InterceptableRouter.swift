//
// RouteComposer
// InterceptableRouter.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import UIKit

/// The router implementing this protocol should support global tasks.
public protocol InterceptableRouter: Router {

    /// Adds `RoutingInterceptor` instance
    ///
    /// - Parameter interceptor: The `RoutingInterceptor` instance to be executed by `Router` before routing to this step.
    mutating func add<RI: RoutingInterceptor>(_ interceptor: RI) where RI.Context == Any?

    /// Adds ContextTask instance
    ///
    /// - Parameter contextTask: The `ContextTask` instance to be applied by a `Router` immediately after it will find
    ///   or create `UIViewController`.
    mutating func add<CT: ContextTask>(_ contextTask: CT) where CT.ViewController == UIViewController, CT.Context == Any?

    /// Adds PostRoutingTask instance
    ///
    /// - Parameter postTask: The `PostRoutingTask` instance to be executed by a `Router` after routing to this step.
    mutating func add<PT: PostRoutingTask>(_ postTask: PT) where PT.Context == Any?

}
