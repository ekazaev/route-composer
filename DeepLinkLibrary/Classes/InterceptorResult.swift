//
//  InterceptorResult.swift
//  DeepLinkLibrary
//
//  Created by Alexandra Mikhailouskaya on 23/01/2018.
//

import Foundation

/// The result of interceptor's execute method.
///
/// - success: Interceptor finished its task with success. The `Router` may continue deep linking.
/// - failure: Interceptor finished its task with failure. The `Router` should stop deep linking.
public enum InterceptorResult {
    
    /// `InterceptorResult` finished its task with success. The `Router` may continue deep linking.
    case success
    
    /// `InterceptorResult` finished its task with failure. The `Router` should stop deep linking.
    case failure(String?)
    
}
