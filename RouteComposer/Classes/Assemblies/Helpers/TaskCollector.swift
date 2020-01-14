//
// Created by Eugene Kazaev on 31/08/2018.
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
        return !interceptors.isEmpty ? interceptors.count == 1 ? interceptors.first : InterceptorMultiplexer(interceptors) : nil
    }

    var contextTask: AnyContextTask? {
        return !contextTasks.isEmpty ? contextTasks.count == 1 ? contextTasks.first : ContextTaskMultiplexer(contextTasks) : nil
    }

    var postTask: AnyPostRoutingTask? {
        return !postTasks.isEmpty ? postTasks.count == 1 ? postTasks.first : PostRoutingTaskMultiplexer(postTasks) : nil
    }

}

#endif
