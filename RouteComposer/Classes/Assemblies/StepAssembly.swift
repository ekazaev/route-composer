//
// Created by Eugene Kazaev on 05/02/2018.
//

import Foundation
import UIKit

/// Builds a `RoutingStep` instance with the correct settings.
/// ### Keep in mind
/// Both `Finder` and `Factory` instances should deal with the same type of `UIViewController` and `Context` instances.
/// ### Usage
/// ```swift
/// let productScreen = StepAssembly(finder: ProductViewControllerFinder(), factory: ProductViewControllerFactory())
///         .add(LoginInterceptor())
///         .add(ProductViewControllerContextTask())
///         .add(ProductViewControllerPostTask(analyticsManager: AnalyticsManager.sharedInstance))
///         .using(PushToNavigationAction())
///         .from(NavigationControllerStep())
///         .using(DefaultActions.PresentModally())
///         .from(CurrentControllerStep())
///         .assemble()
/// ```
public final class StepAssembly<F: Finder, FC: Factory>: GenericStepAssembly<F, FC>, ActionConnecting
        where
        F.ViewController == FC.ViewController, F.Context == FC.Context {

    let finder: F

    let factory: FC

    public typealias Context = F.Context

    let previousSteps: [RoutingStep]

    /// Constructor
    ///
    /// - Parameters:
    ///   - finder: The `UIViewController` `Finder` instance.
    ///   - factory: The `UIViewController` `Factory` instance.
    public init(finder: F, factory: FC) {
        self.factory = factory
        self.finder = finder
        self.previousSteps = []
    }

    /// Connects previously provided `RoutingStep` instance with an `Action`
    ///
    /// - Parameter action: `Action` instance to be used with a step.
    /// - Returns: `ChainAssembly` to continue building the chain.
    public func using<A: Action>(_ action: A) -> StepChainAssembly<A.ViewController, ViewController, Context> {
        var previousSteps = self.previousSteps
        let step = BaseStep<FactoryBox<FC>>(
                finder: self.finder,
                factory: self.factory,
                action: ActionBox(action),
                interceptor: taskCollector.interceptor(),
                contextTask: taskCollector.contextTask(),
                postTask: taskCollector.postTask(),
                previousStep: nil)
        previousSteps.append(step)
        return StepChainAssembly(previousSteps: previousSteps)
    }

    /// Connects previously provided `RoutingStep` instance with an `Action`
    ///
    /// - Parameter action: `ContainerAction` instance to be used with a step.
    /// - Returns: `ChainAssembly` to continue building the chain.
    public func using<A: ContainerAction>(_ action: A) -> StepChainAssembly<A.ViewController, ViewController, Context> {
        var previousSteps = self.previousSteps
        let step = BaseStep<FactoryBox<FC>>(
                finder: self.finder,
                factory: self.factory,
                action: ContainerActionBox(action),
                interceptor: taskCollector.interceptor(),
                contextTask: taskCollector.contextTask(),
                postTask: taskCollector.postTask(),
                previousStep: nil)
        previousSteps.append(step)
        return StepChainAssembly(previousSteps: previousSteps)
    }

}

public extension StepAssembly where FC: NilEntity {

    public func within<AF: Finder, AFC: AbstractFactory>(_ step: StepWithActionAssembly<AF, AFC>) -> ActionConnectingAssembly<AF, AFC, ViewController, Context> {
        var previousSteps = self.previousSteps
        let currentStep = BaseStep<FactoryBox<FC>>(
                finder: self.finder,
                factory: self.factory,
                action: ActionBox(UIViewController.NilAction()),
                interceptor: taskCollector.interceptor(),
                contextTask: taskCollector.contextTask(),
                postTask: taskCollector.postTask(),
                previousStep: nil)
        previousSteps.append(currentStep)
        return ActionConnectingAssembly(stepToFullFill: step, previousSteps: previousSteps)
    }

    public func within<VC: UIViewController, C>(_ step: DestinationStep<VC, C>) -> LastStepInChainAssembly<ViewController, Context> {
        var previousSteps = self.previousSteps
        let currentStep = BaseStep<FactoryBox<FC>>(
                finder: self.finder,
                factory: self.factory,
                action: ActionBox(UIViewController.NilAction()),
                interceptor: taskCollector.interceptor(),
                contextTask: taskCollector.contextTask(),
                postTask: taskCollector.postTask(),
                previousStep: nil)
        previousSteps.append(currentStep)
        previousSteps.append(step)
        return LastStepInChainAssembly(previousSteps: previousSteps)
    }

}
