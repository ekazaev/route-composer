//
//  InterceptorResult.swift
//  RouteComposer
//
//  Created by Eugene Kazaev on 23/01/2018.
//

import Foundation

/// The result of the interceptor's `RoutingInterceptor.execute(...)` method.
///
/// - continueRouting: Interceptor finished its task with success. The `Router` may continue navigation process.
/// - failure: Interceptor finished its task with failure. The `Router` should stop navigation process.
public enum InterceptorResult {

    /// `InterceptorResult` finished its task with success. The `Router` may continue navigation process.
    case continueRouting

    /// `InterceptorResult` finished its task with failure. The `Router` should stop navigation process.
    case failure(Error)

}

public extension InterceptorResult {

    /// Returns `true` if `InterceptorResult` is `.continueRouting`
    var isSuccessful: Bool {
        guard case .continueRouting = self else {
            return false
        }
        return true
    }

    // Returns SDK's `Result` value.
    var value: Result<Void, Error> {
        switch self {
        case .continueRouting:
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }

    /// Returns the `Error` instance of the `InterceptorResult`.
    /// - Throws: The `RoutingError` if `InterceptorResult` is `continueRouting`.
    func getError() throws -> Error {
        guard case let .failure(error) = self else {
            throw RoutingError.generic(.init("Routing Interceptor finished its task with success"))
        }
        return error
    }

}
