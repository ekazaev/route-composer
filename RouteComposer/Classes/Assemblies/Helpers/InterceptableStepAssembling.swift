//
// RouteComposer
// InterceptableStepAssembling.swift
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

/// Assembly protocol allowing to build an interceptable step.
protocol InterceptableStepAssembling {

    // MARK: Associated types

    /// Supported `UIViewController` type
    associatedtype ViewController: UIViewController

    /// Supported `Context` type
    associatedtype Context

    // MARK: Methods to implement

    /// Adds `RoutingInterceptor` instance.
    /// This action does not contain type safety checks to avoid complications.
    ///
    /// - Parameter interceptor: The `RoutingInterceptor` instance to be executed by `Router` before the navigation process
    ///   to this step.
    func adding<RI: RoutingInterceptor>(_ interceptor: RI) -> Self where RI.Context == Context

    /// Adds `ContextTask` instance
    ///
    /// - Parameter contextTask: The `ContextTask` instance to be applied by a `Router` immediately after it
    ///   will find or create `UIViewController`.
    func adding<CT: ContextTask>(_ contextTask: CT) -> Self where CT.ViewController == ViewController, CT.Context == Context

    /// Adds `PostRoutingTask` instance.
    /// This action does not contain type safety checks to avoid complications.
    ///
    /// - Parameter postTask: The `PostRoutingTask` instance to be executed by a `Router` after the navigation process.
    func adding<PT: PostRoutingTask>(_ postTask: PT) -> Self where PT.Context == Context

}
