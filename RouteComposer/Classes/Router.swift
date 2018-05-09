//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit
import Foundation

/// Base router protocol.
public protocol Router {

    /// `Logger` instance to be used by the `Router`.
    var logger: Logger? { get }

    @discardableResult
    /// Routes application to the `RoutingDestination` provided.
    ///
    /// - Parameters:
    ///   - destination: `RoutingDestination` instance.
    ///   - animated: when true - routing should be animated where possible.
    ///   - completion: completion block.
    /// - Returns: `RoutingResult` instance.
    func deepLinkTo<D: RoutingDestination>(destination: D, animated: Bool, completion: ((_: Bool) -> Void)?) -> RoutingResult

}
