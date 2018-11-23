//
//  InterceptorResult.swift
//  RouteComposer
//
//  Created by Eugene Kazaev on 23/01/2018.
//

import Foundation

/// The result of the interceptor's `execute` method.
///
/// - success: Interceptor finished its task with success. The `Router` may continue navigation process.
/// - failure: Interceptor finished its task with failure. The `Router` should stop navigation process.
public enum InterceptorResult {

    /// `InterceptorResult` finished its task with success. The `Router` may continue navigation process.
    case success

    /// `InterceptorResult` finished its task with failure. The `Router` should stop navigation process.
    case failure(Error)

}
