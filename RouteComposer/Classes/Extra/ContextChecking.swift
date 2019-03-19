//
// Created by Eugene Kazaev on 2019-03-19.
// Copyright © 2019 HBC Digital. All rights reserved.
//

import Foundation
import UIKit

/// `UIViewController` instance should extend this protocol to be used with `ClassWithContextFinder`
public protocol ContextChecking where Self: UIViewController {

    /// The context type associated with a `ContextChecking` `UIViewController`
    associatedtype Context

    /// If this view controller is suitable for the `Context` instance provided. Example: It is already showing the provided
    /// context data or is willing to do so, then it should return `true` or `false` if not.
    /// - Parameters:
    ///     - context: The `Context` instance provided to the `Router`
    func isTarget(for context: Context) -> Bool

}
