//
// Created by Eugene Kazaev on 05/02/2018.
//

import Foundation

public class ScreenStepAssembly<F: Finder, FC: Factory> where F.ViewController == FC.ViewController, F.Context == FC.Context {

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

        public func from(_ previousStep: ChainingStep) -> Self {
            self.previousSteps.append(previousStep)
            return self
        }

        public func from(_ previousStep: RoutingStep) -> ScreenStepAssembly.LastStepInChainAssembly {
            self.previousSteps.append(previousStep)
            return ScreenStepAssembly.LastStepInChainAssembly(assembly: assembly, previousSteps: previousSteps)
        }
    }

    public class LastStepInChainAssembly {

        private var previousSteps: [RoutingStep]

        fileprivate var assembly: ScreenStepAssembly

        // Internal init protects from instantiating builder outside of the library
        init(assembly: ScreenStepAssembly, previousSteps: [RoutingStep]) {
            self.assembly = assembly
            self.previousSteps = previousSteps
        }

        public func assemble() -> RoutingStep {
            return assembly.assemble(from: chain(previousSteps))
        }

    }

    private var finder: F

    private var factory: FC

    private var interceptors: [AnyRouterInterceptor] = []

    private var postTasks: [AnyPostRoutingTask] = []

    public init(finder: F, factory: FC) {
        self.factory = factory
        self.finder = finder
    }

    /// Interceptor instance to be executed by router before routing to this step.
    public func add<R: RouterInterceptor>(_ interceptor: R) -> Self {
        self.interceptors.append(RouterInterceptorBox(interceptor))
        return self
    }

    /// PostRoutingTask instance to be executed by a router after routing to this step.
    public func add<P: PostRoutingTask>(_ postTask: P) -> Self {
        self.postTasks.append(PostRoutingTaskBox(postTask))
        return self
    }

    public func from(_ previousStep: RoutingStep) -> LastStepInChainAssembly {
        return LastStepInChainAssembly(assembly: self, previousSteps: [previousStep])
    }

    public func from(_ previousStep: ChainingStep) -> ScreenStepChainAssembly {
        let stepBuilder = ScreenStepChainAssembly(assembly: self, firstStep: previousStep)
        return stepBuilder
    }

    public func assemble(from step: RoutingStep) -> RoutingStep {
        var finalFinder: F? = finder
        if let _ = finder as? NilFinder<F.ViewController, F.Context> {
            finalFinder = nil
        }

        var finalFactory: FC? = factory
        if let _ = factory as? NilFactory<FC.ViewController, FC.Context> {
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
