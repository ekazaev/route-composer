//
// Created by Eugene Kazaev on 05/02/2018.
//

import Foundation

/// Builder class that helps to create a routing step with correct settings.
/// ### Keep in mind
/// Both finder and Factory instances should deal with same type of UIViewController and Content instances.
/// ### Usage
/// ```swift
/// let productScreen = ScreenStepAssembly(finder: ProductViewControllerFinder(), factory: ProductViewControllerFactory(action: PushToNavigationAction()))
///         .add(LoginInterceptor())
///         .add(ProductViewControllerContentTask())
///         .add(ProductViewControllerPostTask(analyticsManager: AnalyticsManager.sharedInstance))
///         .from(NavigationControllerStep(action: PresentModallyAction()))
///         .from(CurrentControllerStep())
///         .assemble()
/// ```
public class ScreenStepAssembly<F: Finder, FC: Factory> where F.ViewController == FC.ViewController, F.Context == FC.Context {

    /// Nested builder that does not allow to add settings after user started to add steps to build current step from
    public class ScreenStepChainAssembly {

        private var previousSteps: [RoutingStep] = []

        fileprivate var assembly: ScreenStepAssembly

        /// Internal init protects from instantiating builder outside of the library
        init(assembly: ScreenStepAssembly, firstStep: RoutingStep) {
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

        /// Previous step to start build current step from
        ///
        /// - Parameter previousStep: Instance of RoutingStep
        public func from(_ previousStep: RoutingStep) -> ScreenStepAssembly.LastStepInChainAssembly {
            self.previousSteps.append(previousStep)
            return ScreenStepAssembly.LastStepInChainAssembly(assembly: assembly, previousSteps: previousSteps)
        }
    }

    /// Nested builder that does not allow to add steps from non-chainable step
    public class LastStepInChainAssembly {

        private var previousSteps: [RoutingStep]

        fileprivate var assembly: ScreenStepAssembly

        /// Internal init protects from instantiating builder outside of the library
        init(assembly: ScreenStepAssembly, previousSteps: [RoutingStep]) {
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

    private var contentTasks: [AnyContextTask] = []

    private var postTasks: [AnyPostRoutingTask] = []

    /// Constructor
    ///
    /// - Parameters:
    ///   - finder: UIViewController finder.
    ///   - factory: UIViewController factory.
    public init(finder: F, factory: FC) {
        self.factory = factory
        self.finder = finder
    }

    /// Add routing interceptor instance
    ///
    /// - Parameter interceptor: Interceptor instance to be executed by router before routing to this step.
    public func add<R: RoutingInterceptor>(_ interceptor: R) -> Self {
        self.interceptors.append(RoutingInterceptorBox(interceptor))
        return self
    }

    /// Add context task instance
    ///
    /// - Parameter contentTask: ContextTask instance to be executed by a router immediately after it will find or create UIViewController.
    public func add<CT: ContextTask>(_ contentTask: CT) -> Self where CT.ViewController == FC.ViewController, CT.ViewController == F.ViewController, CT.Context == FC.Context, CT.Context == F.Context {
        self.contentTasks.append(ContextTaskBox(contentTask))
        return self
    }

    /// Add PostRoutingTask instance
    ///
    /// - Parameter postTask: PostRoutingTask instance to be executed by a router after routing to this step.
    public func add<P: PostRoutingTask>(_ postTask: P) -> Self {
        self.postTasks.append(PostRoutingTaskBox(postTask))
        return self
    }

    /// Previous step to start build current step from
    ///
    /// - Parameter previousStep: Instance of RoutingStep
    public func from(_ previousStep: RoutingStep) -> LastStepInChainAssembly {
        return LastStepInChainAssembly(assembly: self, previousSteps: [previousStep])
    }

    /// Basic step to start build current step from
    ///
    /// - Parameter previousStep: Instance of ChainingStep
    public func from<F, FC>(_ previousStep: BasicStep<F, FC>) -> ScreenStepChainAssembly {
        let stepBuilder = ScreenStepChainAssembly(assembly: self, firstStep: previousStep.routingStep)
        return stepBuilder
    }

    /// Previous step to start build current step from
    ///
    /// - Parameter previousStep: Instance of ChainingStep
    public func from(_ previousStep: RoutingStep & ChainingStep) -> ScreenStepChainAssembly {
        let stepBuilder = ScreenStepChainAssembly(assembly: self, firstStep: previousStep)
        return stepBuilder
    }

    /// Assemble all the provided settings.
    ///
    /// - Parameter step: Instance of RoutingStep to start to build current step from.
    /// - Returns: Instance of RoutingStep with all the settings provided inside.
    public func assemble(from step: RoutingStep) -> RoutingStep {
        return FinalRoutingStep(
                finder: finder,
                factory: factory,
                interceptor: interceptors.count > 0 ? interceptors.count == 1 ? interceptors.first : InterceptorMultiplexer(interceptors) : nil,
                contextTask: contentTasks.count > 0 ? contentTasks.count == 1 ? contentTasks.first : ContextTaskMultiplexer(contentTasks) : nil,
                postTask: postTasks.count > 0 ? postTasks.count == 1 ? postTasks.first : PostRoutingTaskMultiplexer(postTasks) : nil,
                previousStep: step)
    }

}
