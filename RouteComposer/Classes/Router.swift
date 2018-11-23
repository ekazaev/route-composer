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
