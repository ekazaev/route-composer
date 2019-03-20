//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright © 2018 HBC Digital. All rights reserved.
//

import UIKit
import Foundation

/// Base router protocol.
public protocol Router {

    /// Navigates an application to the view controller configured in `DestinationStep` with the `Context` provided.
    ///
    /// - Parameters:
    ///   - step: `DestinationStep` instance.
    ///   - context: `Context` instance.
    ///   - animated: if true - the navigation should be animated where it is possible.
    ///   - completion: completion block.
    func navigate<ViewController: UIViewController, Context>(to step: DestinationStep<ViewController, Context>,
                                                             with context: Context,
                                                             animated: Bool,
                                                             completion: ((_: RoutingResult) -> Void)?) throws

}

public extension Router {


    /// Navigates an application to the view controller configured in `DestinationStep` with the `Context` set to `Any?`.
    ///
    /// - Parameters:
    ///   - step: `DestinationStep` instance.
    ///   - animated: if true - the navigation should be animated where it is possible.
    ///   - completion: completion block.
    func navigate<ViewController: UIViewController>(to step: DestinationStep<ViewController, Any?>,
                                                    animated: Bool,
                                                    completion: ((_: RoutingResult) -> Void)?) throws {
        try navigate(to: step, with: nil, animated: animated, completion: completion)
    }

    /// Navigates an application to the view controller configured in `DestinationStep` with the `Context` set to `Void`.
    ///
    /// - Parameters:
    ///   - step: `DestinationStep` instance.
    ///   - animated: if true - the navigation should be animated where it is possible.
    ///   - completion: completion block.
    func navigate<ViewController: UIViewController>(to step: DestinationStep<ViewController, Void>,
                                                    animated: Bool,
                                                    completion: ((_: RoutingResult) -> Void)?) throws {
        try navigate(to: step, with: (), animated: animated, completion: completion)
    }

}
