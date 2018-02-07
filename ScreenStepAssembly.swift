//
// Created by Eugene Kazaev on 05/02/2018.
//

import Foundation

public class ScreenStepAssembly {

    public class ScreenStepChainAssembly {

        private var previousSteps: [RoutingStep] = []

        fileprivate var assembly: ScreenStepAssembly

        // Internal init protects from instantiating builder outside of the library
        init(assembly: ScreenStepAssembly, firstStep: RoutingStep) {
            self.assembly = assembly
            previousSteps.append(firstStep)
        }

        public func assemble() -> RoutingStep {
            return assembly.assemble(from: chain(previousSteps))
        }
    }

    private var factory: Factory?

    private var interceptors: [RouterInterceptor] = []

    private var postTasks: [PostRoutingTask] = []

    private var finder: DeepLinkFinder?

    private weak var stepBuilder: ScreenStepChainAssembly?

    public init(finder: DeepLinkFinder? = nil, factory: Factory? = nil) {
        self.finder = finder
        self.factory = factory
    }
}

public extension ScreenStepAssembly {

    func add(_ interceptor: RouterInterceptor) -> Self {
        self.interceptors.append(interceptor)
        return self
    }

    func add(_ postTask: PostRoutingTask) -> Self {
        self.postTasks.append(postTask)
        return self
    }

    func from(_ previousStep: RoutingStep) -> ScreenStepChainAssembly {
        guard let stepBuilder = stepBuilder else {
            let stepBuilder = ScreenStepChainAssembly(assembly: self, firstStep: previousStep)
            self.stepBuilder = stepBuilder
            return stepBuilder
        }
        return stepBuilder
    }

    func assemble(from step: RoutingStep) -> RoutingStep {
        return FinalRoutingStep(
                finder: finder,
                factory: factory,
                interceptor: InterceptorMultiplexer(interceptors),
                postTask: PostRoutingTaskMultiplexer(postTasks),
                step: step)
    }
}

public extension ScreenStepAssembly.ScreenStepChainAssembly {

    func from(_ previousStep: RoutingStep) -> Self {
        self.previousSteps.append(previousStep)
        return self
    }

}
