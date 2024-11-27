//
// RouteComposer
// InterceptableStep.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2024.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation

@MainActor
protocol InterceptableStep where Self: PerformableStep {

    var interceptor: AnyRoutingInterceptor? { get }

    var postTask: AnyPostRoutingTask? { get }

    var contextTask: AnyContextTask? { get }

}
