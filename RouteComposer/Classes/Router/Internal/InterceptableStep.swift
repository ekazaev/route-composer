//
//  InterceptableStep.swift
//  RouteComposer
//
//  Created by Eugene Kazaev on 20/02/2018.
//

#if os(iOS)

import Foundation

protocol InterceptableStep where Self: PerformableStep {

    var interceptor: AnyRoutingInterceptor? { get }

    var postTask: AnyPostRoutingTask? { get }

    var contextTask: AnyContextTask? { get }

}

#endif
