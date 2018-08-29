//
//  InterceptorResult.swift
//  RouteComposer
//
//  Created by Alexandra Mikhailouskaya on 23/01/2018.
//

import Foundation

/// The result of interceptor's execute method.
///
/// - success: Interceptor finished its task with success. The `Router` may continue routing.
/// - failure: Interceptor finished its task with failure. The `Router` should stop routing.
public enum InterceptorResult {

    /// `InterceptorResult` finished its task with success. The `Router` may continue routing.
    case success

    /// `InterceptorResult` finished its task with failure. The `Router` should stop routing.
    case failure(String?)

}
