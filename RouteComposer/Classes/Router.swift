//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import UIKit
import Foundation

/// Base router protocol.
public protocol Router {

    /// Navigates an application to the `RoutingDestination` provided.
    ///
    /// - Parameters:
    ///   - destination: `RoutingDestination` instance.
    ///   - animated: if true - the navigation should be animated where possible.
    ///   - completion: completion block.
    /// - Returns: `RoutingResult` instance.
    @discardableResult
    func navigate(to step: RoutingStep, with context: Any?, animated: Bool, completion: ((_: RoutingResult) -> Void)?) -> RoutingResult

}
