//
// Created by Eugene Kazaev on 05/02/2018.
//

import Foundation

public class ViewControllerAssembly {

    public class StepChainAssembly {

        private var previousSteps: [RoutingStep] = []

        fileprivate var assembly: ViewControllerAssembly

        // Internal init protects from instantiating builder outside of the library
        init(assembly: ViewControllerAssembly, firstStep: RoutingStep) {
            self.assembly = assembly
            previousSteps.append(firstStep)
        }

        public func assemble() -> ViewControllerStep {
            return assembly.assemble(from: buildStepsChain())
        }

        private func buildStepsChain() -> RoutingStep {
            if previousSteps.count == 1, let step = previousSteps.first {
                return step
            } else {
                guard let previousSteps = previousSteps as? [ChainableStep] else {
                    fatalError("Steps in StepChainBuilder should be chainable")
                }
                return chain(previousSteps)
            }
        }
    }

    private var factory: Factory?

    private var interceptors: [RouterInterceptor] = []

    private var postTasks: [PostRoutingTask] = []

    private var finder: DeepLinkFinder?

    private weak var stepBuilder: StepChainAssembly?

    public init(finder: DeepLinkFinder? = nil, factory: Factory? = nil) {
        self.finder = finder
        self.factory = factory
    }
}

public extension ViewControllerAssembly {

    func add(_ interceptor: RouterInterceptor) -> Self {
        self.interceptors.append(interceptor)
        return self
    }

    func add(_ postTask: PostRoutingTask) -> Self {
        self.postTasks.append(postTask)
        return self
    }

    func from(_ previousStep: RoutingStep) -> StepChainAssembly {
        guard let stepBuilder = stepBuilder else {
            let stepBuilder = StepChainAssembly(assembly: self, firstStep: previousStep)
            self.stepBuilder = stepBuilder
            return stepBuilder
        }
        return stepBuilder
    }

    func assemble(from step: RoutingStep) -> ViewControllerStep {
        return ViewControllerStep(
                finder: finder,
                factory: factory,
                interceptor: interceptors.count > 1 ? InterceptorMultiplexer(interceptors) : interceptors.first,
                postTask: postTasks.count > 1 ? PostRoutingTaskMultiplexer(postTasks) : postTasks.first,
                step: step)
    }
}

public extension ViewControllerAssembly.StepChainAssembly {

    func from(_ previousStep: RoutingStep) -> Self {
        self.previousSteps.append(previousStep)
        return self
    }

}
