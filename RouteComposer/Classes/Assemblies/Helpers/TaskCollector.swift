//
// RouteComposer
// TaskCollector.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
//

#if os(iOS)

import Foundation

struct TaskCollector: TaskProvider {

    private var interceptors: [AnyRoutingInterceptor] = []

    private var contextTasks: [AnyContextTask] = []

    private var postTasks: [AnyPostRoutingTask] = []

    mutating func add<RI: RoutingInterceptor>(_ interceptor: RI) {
        interceptors.append(RoutingInterceptorBox(interceptor))
    }

    mutating func add<CT: ContextTask>(_ contextTask: CT) {
        contextTasks.append(ContextTaskBox(contextTask))
    }

    mutating func add<PT: PostRoutingTask>(_ postTask: PT) {
        postTasks.append(PostRoutingTaskBox(postTask))
    }

    var interceptor: AnyRoutingInterceptor? {
        !interceptors.isEmpty ? interceptors.count == 1 ? interceptors.first : InterceptorMultiplexer(interceptors) : nil
    }

    var contextTask: AnyContextTask? {
        !contextTasks.isEmpty ? contextTasks.count == 1 ? contextTasks.first : ContextTaskMultiplexer(contextTasks) : nil
    }

    var postTask: AnyPostRoutingTask? {
        !postTasks.isEmpty ? postTasks.count == 1 ? postTasks.first : PostRoutingTaskMultiplexer(postTasks) : nil
    }

}

#endif
