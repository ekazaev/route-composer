//
//  ActionResult.swift
//  RouteComposer
//
//  Created by Eugene Kazaev on 08/02/2018.
//

import Foundation
import UIKit

/// The result of the `Action`'s `perform` method.
///
/// - continueRouting: The `Action` was able to integrate a view controller into the stack
/// - failure: The `Action` was not able to integrate a view controller into the stack. Navigation process should not continue
public enum ActionResult {

    /** The `Action` was able to build a view controller into the stack. */
    case continueRouting

    /** The `Action` was not able to build a view controller into the stack. Navigation should not continue */
    case failure(Error)

}

public extension ActionResult {

    /// Returns `true` if `ActionResult` is `.continueRouting`
    var isSuccessful: Bool {
        guard case .continueRouting = self else {
            return false
        }
        return true
    }

}
