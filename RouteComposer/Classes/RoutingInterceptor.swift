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

    /// Method that will be called by `Router` to start interceptor.
    ///
    /// - Parameters:
    ///   - destination: Destination instance provided to the `Router`
    ///   - completion: Completion block with a result.
    ///
    /// ###NB
    /// For `Router` to continue routing, completion of interceptor's execute method **MUST** to be called
    /// in any scenario.
    /// Otherwise `Router` will stay in limbo state waiting for `RoutingInterceptor` to finish its action.
    func execute(for destination: Destination, completion: @escaping (_: InterceptorResult) -> Void)

}
