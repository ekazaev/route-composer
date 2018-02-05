//
// Created by Eugene Kazaev on 05/02/2018.
//

import Foundation

public class ViewControllerAssemblyBuilder {

    private var factory: Factory?

    private var interceptors: [RouterInterceptor] = []

    private var postTasks: [PostRoutingTask] = []

    private var previousSteps: [ChainableStep] = []

    private var previousStep: RoutingStep

    private var finder: DeepLinkFinder?

    public init(finder: DeepLinkFinder? = nil, factory: Factory? = nil, from previousStep: RoutingStep) {
        self.finder = finder
        self.factory = factory
        self.previousStep = previousStep
    }

}

public extension ViewControllerAssemblyBuilder {

    func from(_ previousStep: ChainableStep) -> Self {
        self.previousSteps.append(previousStep)
        return self
    }

    func add(_ interceptor: RouterInterceptor) -> Self {
        self.interceptors.append(interceptor)
        return self
    }

    func add(_ postTask: PostRoutingTask) -> Self {
        self.postTasks.append(postTask)
        return self
    }

    func build() -> ViewControllerAssembly {
        var step = previousStep
        if previousSteps.count > 0 {
            guard let previousStep = previousStep as? ChainableStep else {
                fatalError("View Controller assembly should be chainable to add other steps in the chain")
            }
            var steps = previousSteps
            steps.insert(previousStep, at: 0)
            step = chain(steps)
        }


        return ViewControllerAssembly(
                finder: finder,
                factory: factory,
                interceptor: interceptors.count > 1 ? InterceptorMultiplexer(interceptors) : interceptors.first,
                postTask: postTasks.count > 1 ? PostRoutingTaskMultiplexer(postTasks) : postTasks.first,
                step: step)
    }
}
