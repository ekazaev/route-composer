//
// Created by Eugene Kazaev on 17/01/2018.
//

import Foundation

/// Router interceptor is called before the actual deeplinking(navigation) happens in case it's defined,
/// e.g. user should be logged in.
///
/// ### NB
/// Interceptor is an asynchronous action. For router to continue routing, completion of interceptor's execute method MUST to be called.
/// Otherwise router will stay in limbo state waiting for interceptor to finish its action.
public protocol RouterInterceptor {

    associatedtype Context

    /// Method that will be called by Router to start interceptor.
    ///
    /// - Parameters:
    ///   - context: Context instance that was provided to Router.
    ///   - completion: Completion block with a result.
    ///
    /// ###NB
    /// For router to continue routing, completion of interceptor's execute method MUST to be called.
    /// Otherwise router will stay in limbo state waiting for interceptor to finish its action.
    func execute(with context: Context?, completion: @escaping (_: InterceptorResult) -> Void)

}
