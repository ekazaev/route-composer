//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import UIKit
import Foundation

/// Base router protocol.
public protocol Router {

    /// Routes application to the `RoutingDestination` provided.
    ///
    /// - Parameters:
    ///   - destination: `RoutingDestination` instance.
    ///   - animated: when true - routing should be animated where possible.
    ///   - completion: completion block.
    /// - Returns: `RoutingResult` instance.
    @discardableResult
    func navigate<D: RoutingDestination>(to destination: D, animated: Bool, completion: ((_: RoutingResult) -> Void)?) -> RoutingResult

}
