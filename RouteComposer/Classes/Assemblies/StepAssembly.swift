//
// Created by Eugene Kazaev on 05/02/2018.
//

import Foundation

/// Builder class that helps to create a `RoutingStep` instance with correct settings.
/// ### Keep in mind
/// Both `Finder` and `Factory` instances should deal with same type of `UIViewController` and `Context` instances.
/// ### Usage
/// ```swift
/// let productScreen = StepAssembly(finder: ProductViewControllerFinder(), factory: ProductViewControllerFactory(action: PushToNavigationAction()))
///         .add(LoginInterceptor())
///         .add(ProductViewControllerContextTask())
///         .add(ProductViewControllerPostTask(analyticsManager: AnalyticsManager.sharedInstance))
///         .from(NavigationControllerStep(action: DefaultActions.PresentModally()))
///         .from(CurrentControllerStep())
///         .assemble()
/// ```
public class StepAssembly<F: Finder, FC: Factory> where F.ViewController == FC.ViewController, F.Context == FC.Context {

    /// Nested builder that does not allow to add settings after user started to add steps to build current step from
    public class ScreenStepChainAssembly {

        private var previousSteps: [RoutingStep] = []

        fileprivate var assembly: StepAssembly

        /// Internal init protects from instantiating builder outside of the library
        init(assembly: StepAssembly, firstStep: RoutingStep) {
            self.assembly = assembly
            previousSteps.append(firstStep)
        }

        /// Assemble all the provided settings.
        ///
        /// - Returns: Instance of RoutingStep with all the settings provided inside.
        public func assemble() -> RoutingStep {
            return assembly.assemble(from: chain(previousSteps))
        }

        /// Previous step to start build current step from
        ///
        /// - Parameter previousStep: Instance of RoutingStep
        public func from(_ previousStep: RoutingStep & ChainingStep) -> Self {
            self.previousSteps.append(previousStep)
            return self
        }

        /// Basic step to start build current step from
        ///
        /// - Parameter previousStep: Instance of ChainingStep
        public func from<F, FC>(_ previousStep: BasicStep<F, FC>) -> ScreenStepChainAssembly {
            self.previousSteps.append(previousStep.routingStep)
            return self
        }

        /// Previous `RoutingStep` to start build current step from
        ///
        /// - Parameter previousStep: Instance of RoutingStep
        public func from(_ previousStep: RoutingStep) -> StepAssembly.LastStepInChainAssembly {
            self.previousSteps.append(previousStep)
            return StepAssembly.LastStepInChainAssembly(assembly: assembly, previousSteps: previousSteps)
        }
    }

    /// Nested builder that does not allow to add steps from non-chainable step
    public class LastStepInChainAssembly {

        private var previousSteps: [RoutingStep]

        fileprivate var assembly: StepAssembly

        /// Internal init protects from instantiating builder outside of the library
        init(assembly: StepAssembly, previousSteps: [RoutingStep]) {
            self.assembly = assembly
            self.previousSteps = previousSteps
        }

        /// Assemble all the provided settings.
        ///
        /// - Returns: Instance of RoutingStep with all the settings provided inside.
        public func assemble() -> RoutingStep {
            return assembly.assemble(from: chain(previousSteps))
        }

    }

    private var finder: F

    private var factory: FC

    private var interceptors: [AnyRoutingInterceptor] = []

    private var contextTasks: [AnyContextTask] = []

    private var postTasks: [AnyPostRoutingTask] = []

    /// Constructor
    ///
    /// - Parameters:
    ///   - finder: The `UIViewController` `Finder` instance.
    ///   - factory: The `UIViewController` `Factory` instance.
    public init(finder: F, factory: FC) {
        self.factory = factory
        self.finder = finder
    }

    /// Adds routing interceptor instance
    ///
    /// - Parameter interceptor: The `RoutingInterceptor` instance to be executed by `Router` before routing to this step.
    public func add<R: RoutingInterceptor>(_ interceptor: R) -> Self {
        self.interceptors.append(RoutingInterceptorBox(interceptor))
        return self
    }

    /// Adds context task instance
    ///
    /// - Parameter contextTask: The `ContextTask` instance to be executed by a `Router` immediately after it will find or create UIViewController.
    public func add<CT: ContextTask>(_ contextTask: CT) -> Self where CT.ViewController == FC.ViewController, CT.ViewController == F.ViewController, CT.Context == FC.Context, CT.Context == F.Context {
        self.contextTasks.append(ContextTaskBox(contextTask))
        return self
    }

    /// Adds PostRoutingTask instance
    ///
    /// - Parameter postTask: The `PostRoutingTask` instance to be executed by a `Router` after routing to this step.
    public func add<P: PostRoutingTask>(_ postTask: P) -> Self {
        self.postTasks.append(PostRoutingTaskBox(postTask))
        return self
    }

    /// Previous `RoutingStep` to start build current step from
    ///
    /// - Parameter previousStep: The instance of `RoutingStep`
    public func from(_ previousStep: RoutingStep) -> LastStepInChainAssembly {
        return LastStepInChainAssembly(assembly: self, previousSteps: [previousStep])
    }

    /// Basic step to start build current step from
    ///
    /// - Parameter previousStep: The instance of `BasicStep`
    public func from<F, FC>(_ previousStep: BasicStep<F, FC>) -> ScreenStepChainAssembly {
        let stepBuilder = ScreenStepChainAssembly(assembly: self, firstStep: previousStep.routingStep)
        return stepBuilder
    }

    /// Previous step to start build current step from
    ///
    /// - Parameter previousStep: The instance of `RoutingStep` and ChainingStep`
    public func from(_ previousStep: RoutingStep & ChainingStep) -> ScreenStepChainAssembly {
        let stepBuilder = ScreenStepChainAssembly(assembly: self, firstStep: previousStep)
        return stepBuilder
    }

    /// Assemble all the provided settings.
    ///
    /// - Parameter step: The instance of `RoutingStep` to start to build current step from.
    /// - Returns: The instance of `RoutingStep` with all the settings provided inside.
    public func assemble(from step: RoutingStep) -> RoutingStep {
        return FinalRoutingStep(
                finder: finder,
                factory: factory,
                interceptor: interceptors.count > 0 ? interceptors.count == 1 ? interceptors.first : InterceptorMultiplexer(interceptors) : nil,
                contextTask: contextTasks.count > 0 ? contextTasks.count == 1 ? contextTasks.first : ContextTaskMultiplexer(contextTasks) : nil,
                postTask: postTasks.count > 0 ? postTasks.count == 1 ? postTasks.first : PostRoutingTaskMultiplexer(postTasks) : nil,
                previousStep: step)
    }

}
