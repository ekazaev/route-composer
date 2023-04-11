//
// RouteComposer
// TaskCollector.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation

struct TaskCollector: TaskProvider {

    private var interceptors: [AnyRoutingInterceptor] = []

    private var contextTasks: [AnyContextTask] = []

    private var postTasks: [AnyPostRoutingTask] = []

    mutating func add(_ interceptor: some RoutingInterceptor) {
        interceptors.append(RoutingInterceptorBox(interceptor))
    }

    mutating func add(_ contextTask: some ContextTask) {
        contextTasks.append(ContextTaskBox(contextTask))
    }

    mutating func add(_ postTask: some PostRoutingTask) {
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
