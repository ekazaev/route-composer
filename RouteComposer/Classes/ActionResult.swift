//
//  ActionResult.swift
//  RouteComposer
//
//  Created by Eugene Kazaev on 08/02/2018.
//

import Foundation
import UIKit

/// The result of `Action`'s perform method.
///
/// - continueRouting: The `Action` was able to build view controller into the stack
/// - failure: The `Action` was not able to build view controller into the stack. Routing should not continue
public enum ActionResult {

    /** The `Action` was able to build view controller into the stack. */
    case continueRouting

    /** The `Action` was not able to build view controller into the stack. Routing should not continue */
    case failure(String?)

}
