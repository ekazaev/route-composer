//
// Created by Eugene Kazaev on 17/01/2018.
//

import Foundation

/// Routing interceptor is called before the actual deeplinking(navigation) happens in case it's defined,
/// e.g. user should be logged in.
///
/// ### NB
/// Interceptor is an asynchronous action. For the `Router` to continue routing, completion of interceptor's
/// execute method **MUST** be called.
/// Otherwise, the `Router` will stay in limbo state waiting for the interceptor to finish its action.
public protocol RoutingInterceptor {

    /// `RoutingDestination` type associated with `RoutingInterceptor`
    associatedtype Destination: RoutingDestination

    /// If the `RoutingInterceptor` can tell the `Router` if it can be executed or not and does not need to be async
    /// - it should overload this method.
    /// The `Router` will call it before the routing process and if `RoutingInterceptor` is not able to allow
    /// the routing process to start it can stop `Router`
    /// and the result of routing will be `.unhandled` without any changes in view controller stack.
    ///
    /// - Parameters:
    ///   - destination: The `Destination` instance if it was provided to the `Router`.
    /// - Throws: The `RoutingError` if the `RoutingInterceptor` can not prepare itself or routing can not start
    ///   with the `Context` instance provided.
    mutating func prepare(with destination: Destination) throws

    /// Method that will be called by `Router` to start interceptor.
    ///
    /// - Parameters:
    ///   - destination: Destination instance provided to the `Router`
    ///   - completion: Completion block with a result.
    ///
    /// ###NB
    /// For the `Router` to continue routing, the `completion` block of interceptor **MUST** to be called
    /// in any case by the implementation of this method.
    /// Otherwise `Router` will stay in limbo waiting for `RoutingInterceptor` to finish its action.
    func execute(for destination: Destination, completion: @escaping (_: InterceptorResult) -> Void)

}

public extension RoutingInterceptor {

    /// Default implementation.
    func prepare(with destination: Destination) throws {

    }

}
