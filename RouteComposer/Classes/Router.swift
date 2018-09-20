//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import UIKit
import Foundation

/// Base router protocol.
public protocol Router {

    /// Navigates an application to the `DestinationStep` with the `Context` provided.
    ///
    /// - Parameters:
    ///   - step: `DestinationStep` instance.
    ///   - context: A `Context` instance.
    ///   - animated: if true - the navigation should be animated where possible.
    ///   - completion: completion block.
    /// - Returns: `RoutingResult` instance.
    @discardableResult
    func navigate<ViewController: UIViewController, Context>(to step: DestinationStep<ViewController, Context>,
                                                             with context: Context,
                                                             animated: Bool,
                                                             completion: ((_: RoutingResult) -> Void)?) -> RoutingResult

}
