//
// Created by Eugene Kazaev on 31/08/2018.
//

import Foundation

struct TaskCollector: TaskProvider {

    private var interceptors: [AnyRoutingInterceptor] = []

    private var contextTasks: [AnyContextTask] = []

    private var postTasks: [AnyPostRoutingTask] = []

    mutating func add<R: RoutingInterceptor>(_ interceptor: R) {
        self.interceptors.append(RoutingInterceptorBox(interceptor))
    }

    mutating func add<CT: ContextTask>(_ contextTask: CT) {
        self.contextTasks.append(ContextTaskBox(contextTask))
    }

    mutating func add<P: PostRoutingTask>(_ postTask: P) {
        self.postTasks.append(PostRoutingTaskBox(postTask))
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
