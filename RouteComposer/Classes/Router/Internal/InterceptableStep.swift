//
//  InterceptableStep.swift
//  RouteComposer
//
//  Created by Eugene Kazaev on 20/02/2018.
//

import Foundation

protocol InterceptableStep {

    var interceptor: AnyRoutingInterceptor? { get }

    var postTask: AnyPostRoutingTask? { get }

    var contextTask: AnyContextTask? { get }

}