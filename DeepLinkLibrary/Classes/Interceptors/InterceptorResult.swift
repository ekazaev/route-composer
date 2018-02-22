//
//  InterceptorResult.swift
//  DeepLinkLibrary
//
//  Created by Alexandra Mikhailouskaya on 23/01/2018.
//

import Foundation

public enum InterceptorResult {
    
    /// Interceptor finished its task with success. Router may continue deep linking.
    case success
    
    /// Interceptor finished its task with failure. Router should stop deep linking.
    case failure(String?)
    
}
