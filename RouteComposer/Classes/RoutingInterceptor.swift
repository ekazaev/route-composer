//
// Created by Eugene Kazaev on 17/01/2018.
//

import Foundation

/// `RoutingInterceptor` is called before the actual navigation process happens.
/// e.g. user should be logged in.
///
/// ### NB
/// Interceptor is an asynchronous action. For the `Router` to continue the navigation process, the `completion` block of the interceptor's
/// execute method **MUST** be called.
/// Otherwise, the `Router` will stay in a limbo state waiting for the interceptor to finish its action.
public protocol RoutingInterceptor {

    /// `Context` type associated with `RoutingInterceptor`
    associatedtype Context

    /// The `Router` will call this method before the navigation process. If `RoutingInterceptor` is not able to allow
    /// the navigation process to start it can stop `Router` by throwing an exception.
    ///
    /// - Parameters:
    ///   - context: The `Context` instance that is provided to the `Router`.
    /// - Throws: The `RoutingError` if the `RoutingInterceptor` cannot prepare itself or if the navigation process cannot start
    ///   with the `Context` instance provided.
    mutating func prepare(with context: Context) throws

    /// Method that will be called by `Router` to start interceptor.
    ///
    /// - Parameters:
    ///   - context: `Context` instance provided to the `Router`
    ///   - completion: Completion block with a result.
    ///
    /// ###NB
    /// For the `Router` to continue the navigation process, the `completion` block of interceptor **MUST** be called
    /// by the implementation of this method.
    /// Otherwise `Router` will stay in limbo waiting for `RoutingInterceptor` to finish its action.
    func execute(with context: Context, completion: @escaping (_: InterceptorResult) -> Void)

}

public extension RoutingInterceptor {

    /// Default implementation.
    func prepare(with context: Context) throws {

    }

}
