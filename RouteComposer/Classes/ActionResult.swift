//
//  ActionResult.swift
//  RouteComposer
//
//  Created by Eugene Kazaev on 08/02/2018.
//

import Foundation
import UIKit

/// The result of the `Action`'s `AbstractAction.perform(...)` method.
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

    /// Returns SDK's `Result` value.
    var value: Result<Void, Error> {
        switch self {
        case .continueRouting:
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }

    /// Returns the `Error` instance of the `ActionResult`.
    /// - Throws: The `RoutingError` if `ActionResult` is `continueRouting`.
    func getError() throws -> Error {
        guard case let .failure(error) = self else {
            throw RoutingError.generic(.init("Action successfully integrated a view controller into the stack"))
        }
        return error
    }

}
