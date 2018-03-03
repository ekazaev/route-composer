//
//  InterceptableStep.swift
//  DeepLinkLibrary
//
//  Created by Eugene Kazaev on 20/02/2018.
//

import Foundation

protocol InterceptableStep: RoutingStep {

    var interceptor: AnyRouterInterceptor? { get }

    var postTask: AnyPostRoutingTask? { get }

    var contextTask: AnyContextTask? { get }

}