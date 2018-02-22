//
// Created by Eugene Kazaev on 05/02/2018.
//

import Foundation

public class ScreenStepAssembly<F: Finder, FF: Factory> where F.V == FF.V, F.A == FF.A {

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

    private var finder: F

    private var factory: FF

    private var interceptors: [AnyRouterInterceptor] = []

    private var postTasks: [AnyPostRoutingTask] = []

    private weak var stepBuilder: ScreenStepChainAssembly?

    public init(finder: F, factory: FF) {
        self.factory = factory
        self.finder = finder
    }

}

public extension ScreenStepAssembly {

    /// Interceptor instance to be executed by router before routing to this step.
    func add<R: RouterInterceptor>(_ interceptor: R) -> Self {
        self.interceptors.append(RouterInterceptorBox(interceptor))
        return self
    }

    /// PostRoutingTask instance to be executed by a router after routing to this step.
    func add<P: PostRoutingTask>(_ postTask: P) -> Self {
        self.postTasks.append(PostRoutingTaskBox(postTask))
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
        var finalFinder:F? = finder
        if let _ = finder as? NilFinder<F.V, F.A> {
            finalFinder = nil
        }

        var finalFactory:FF? = factory
        if let _ = factory as? NilFactory<FF.V, FF.A> {
            finalFactory = nil
        }

        return FinalRoutingStep(
                finder: finalFinder,
                factory: finalFactory,
                interceptor: interceptors.count == 1 ? interceptors.first : InterceptorMultiplexer(interceptors),
                postTask: postTasks.count == 1 ? postTasks.first : PostRoutingTaskMultiplexer(postTasks),
                previousStep: step)
    }
}

public extension ScreenStepAssembly.ScreenStepChainAssembly {

    func from(_ previousStep: RoutingStep) -> Self {
        self.previousSteps.append(previousStep)
        return self
    }

}
