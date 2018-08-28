//
// Created by Eugene Kazaev on 05/02/2018.
//

import Foundation
import UIKit

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
public final class StepAssembly<F: Finder, FC: Factory>: GenericStepAssembly<F, FC> where F.ViewController == FC.ViewController, F.Context == FC.Context {
    
    /// Constructor
    ///
    /// - Parameters:
    ///   - finder: The `UIViewController` `Finder` instance.
    ///   - factory: The `UIViewController` `Factory` instance.
    public override init(finder: F, factory: FC) {
        super.init(finder: finder, factory: factory)
    }
    
    /// Assemble all the provided settings.
    ///
    /// - Parameter step: The instance of `RoutingStep` to start to build current step from.
    /// - Returns: The instance of `RoutingStep` with all the settings provided inside.
    override fileprivate func _assemble(from step: RoutingStep) -> RoutingStep & ChainingStep {
        return FinalRoutingStep<FactoryBox<FC>>(
                finder: finder,
                factory: factory,
                interceptor: interceptors.count > 0 ? interceptors.count == 1 ? interceptors.first : InterceptorMultiplexer(interceptors) : nil,
                contextTask: contextTasks.count > 0 ? contextTasks.count == 1 ? contextTasks.first : ContextTaskMultiplexer(contextTasks) : nil,
                postTask: postTasks.count > 0 ? postTasks.count == 1 ? postTasks.first : PostRoutingTaskMultiplexer(postTasks) : nil,
                previousStep: step)
    }
    
}

/// Builder class that helps to create a `RoutingStep` instance with correct settings.
/// ### Keep in mind
/// Both `Finder` and `Factory` instances should deal with same type of `UIViewController` and `Context` instances.
/// ### Usage
/// ```swift
/// let containerScreen = ContainerStepAssembly(finder: ClassFinder(), factory: NavigationControllerFactory(action: GeneralAction.PresentModally()))
///         .add(LoginInterceptor())
///         .add(ProductViewControllerContextTask())
///         .add(ProductViewControllerPostTask(analyticsManager: AnalyticsManager.sharedInstance))
///         .from(CurrentControllerStep())
///         .assemble()
/// ```
public final class ContainerStepAssembly<F: Finder, FC: Container>: GenericStepAssembly<F, FC> where F.ViewController == FC.ViewController, F.Context == FC.Context {
    
    /// Constructor
    ///
    /// - Parameters:
    ///   - finder: The `UIViewController` `Finder` instance.
    ///   - factory: The `UIViewController` `Container` instance.
    public override init(finder: F, factory: FC) {
        super.init(finder: finder, factory: factory)
    }
    
    /// Assemble all the provided settings.
    ///
    /// - Parameter step: The instance of `RoutingStep` to start to build current step from.
    /// - Returns: The instance of `RoutingStep` with all the settings provided inside.
    override fileprivate func _assemble(from step: RoutingStep) -> RoutingStep & ChainingStep {
        return FinalRoutingStep<ContainerFactoryBox<FC>>(
                finder: finder,
                factory: factory,
                interceptor: interceptors.count > 0 ? interceptors.count == 1 ? interceptors.first : InterceptorMultiplexer(interceptors) : nil,
                contextTask: contextTasks.count > 0 ? contextTasks.count == 1 ? contextTasks.first : ContextTaskMultiplexer(contextTasks) : nil,
                postTask: postTasks.count > 0 ? postTasks.count == 1 ? postTasks.first : PostRoutingTaskMultiplexer(postTasks) : nil,
                previousStep: step)
    }
    
}

/// Builder class that helps to create a `RoutingStep` instance with correct settings.
public class GenericStepAssembly<F: Finder, FC: AbstractFactory> where F.ViewController == FC.ViewController, F.Context == FC.Context {
    
    /// Nested builder that does not allow to add settings after user started to add steps to build current step from
    public final class ScreenStepChainAssembly {
        
        private var previousSteps: [RoutingStep] = []
        
        fileprivate var assembly: GenericStepAssembly
        
        /// Internal init protects from instantiating builder outside of the library
        init(assembly: GenericStepAssembly, firstStep: RoutingStep) {
            self.assembly = assembly
            previousSteps.append(firstStep)
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
        public func from(_ previousStep: BasicStepAssembly) -> ScreenStepChainAssembly {
            self.previousSteps.append(previousStep.routingStep)
            return self
        }
        
        /// Previous `RoutingStep` to start build current step from
        ///
        /// - Parameter previousStep: Instance of RoutingStep
        public func from(_ previousStep: RoutingStep) -> GenericStepAssembly.LastStepInChainAssembly {
            self.previousSteps.append(previousStep)
            return GenericStepAssembly.LastStepInChainAssembly(assembly: assembly, previousSteps: previousSteps)
        }
        
    }
    
    /// Nested builder that does not allow to add steps from non-chainable step
    public final class LastStepInChainAssembly {
        
        private var previousSteps: [RoutingStep]
        
        fileprivate var assembly: GenericStepAssembly
        
        /// Internal init protects from instantiating builder outside of the library
        init(assembly: GenericStepAssembly, previousSteps: [RoutingStep]) {
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
    
    fileprivate var finder: F
    
    fileprivate var factory: FC
    
    fileprivate var interceptors: [AnyRoutingInterceptor] = []
    
    fileprivate var contextTasks: [AnyContextTask] = []
    
    fileprivate var postTasks: [AnyPostRoutingTask] = []
    
    /// Constructor
    ///
    /// - Parameters:
    ///   - finder: The `UIViewController` `Finder` instance.
    ///   - factory: The `UIViewController` `Factory` instance.
    fileprivate init(finder: F, factory: FC) {
        self.factory = factory
        self.finder = finder
    }
    
    /// Adds routing interceptor instance
    ///
    /// - Parameter interceptor: The `RoutingInterceptor` instance to be executed by `Router` before routing to this step.
    public final func add<R: RoutingInterceptor>(_ interceptor: R) -> Self {
        self.interceptors.append(RoutingInterceptorBox(interceptor))
        return self
    }
    
    /// Adds context task instance
    ///
    /// - Parameter contextTask: The `ContextTask` instance to be executed by a `Router` immediately after it will find or create UIViewController.
    public final func add<CT: ContextTask>(_ contextTask: CT) -> Self where CT.ViewController == FC.ViewController, CT.ViewController == F.ViewController, CT.Context == FC.Context, CT.Context == F.Context {
        self.contextTasks.append(ContextTaskBox(contextTask))
        return self
    }
    
    /// Adds generic context task instance. Generic means that it can be applied to any view controller with any type of context.
    /// Generic `ContextTask` must have the view controller type casted to `UIViewController` and context type casted  to `Any?`.
    ///
    /// - Parameter contextTask: The `ContextTask` instance to be executed by a `Router` immediately after it will find or create UIViewController.
    public final func add<CT: ContextTask>(_ contextTask: CT) -> Self where CT.ViewController == UIViewController, CT.Context == Any? {
        self.contextTasks.append(ContextTaskBox(contextTask))
        return self
    }
    
    /// Adds PostRoutingTask instance
    ///
    /// - Parameter postTask: The `PostRoutingTask` instance to be executed by a `Router` after routing to this step.
    public final func add<P: PostRoutingTask>(_ postTask: P) -> Self {
        self.postTasks.append(PostRoutingTaskBox(postTask))
        return self
    }
    
    /// Previous `RoutingStep` to start build current step from
    ///
    /// - Parameter previousStep: The instance of `RoutingStep`
    public final func from(_ previousStep: RoutingStep) -> LastStepInChainAssembly {
        return LastStepInChainAssembly(assembly: self, previousSteps: [previousStep])
    }
    
    /// Basic step to start build current step from
    ///
    /// - Parameter previousStep: The instance of `BasicStep`
    public final func from(_ previousStep: BasicStepAssembly) -> ScreenStepChainAssembly {
        let stepBuilder = ScreenStepChainAssembly(assembly: self, firstStep: previousStep.routingStep)
        return stepBuilder
    }
    
    /// Previous step to start build current step from
    ///
    /// - Parameter previousStep: The instance of `RoutingStep` and ChainingStep`
    public final func from(_ previousStep: RoutingStep & ChainingStep) -> ScreenStepChainAssembly {
        let stepBuilder = ScreenStepChainAssembly(assembly: self, firstStep: previousStep)
        return stepBuilder
    }
    
    /// Assemble all the provided settings.
    ///
    /// - Parameter step: The instance of `RoutingStep` to start to build current step from.
    /// - Returns: The instance of `RoutingStep` with all the settings provided inside.
    public final func assemble(from step: RoutingStep) -> RoutingStep {
        return _assemble(from: step)
    }
    
    /// Assemble all the provided settings.
    ///
    /// NB: Must be implemented in the subclass.
    fileprivate func _assemble(from step: RoutingStep) -> RoutingStep & ChainingStep {
        preconditionFailure("\(#function) is not implemented.")
    }
    
}

