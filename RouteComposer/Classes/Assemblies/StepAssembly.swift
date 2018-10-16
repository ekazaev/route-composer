//
// Created by Eugene Kazaev on 05/02/2018.
//

import Foundation
import UIKit

/// Builds a `DestinationStep` instance with the correct settings into a chain of steps.
/// ### NB
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
public final class StepAssembly<F: Finder, FC: Factory>: GenericStepAssembly<F.ViewController, FC.Context>, ActionConnecting
        where F.ViewController == FC.ViewController, F.Context == FC.Context {

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

    public func using<A: Action>(_ action: A) -> StepChainAssembly<ViewController, Context> {
        var previousSteps = self.previousSteps
        let step = BaseStep<FactoryBox<FC>>(
                finder: self.finder,
                factory: self.factory,
                action: ActionBox(action),
                interceptor: taskCollector.getInterceptorsBoxed(),
                contextTask: taskCollector.getContextTasksBoxed(),
                postTask: taskCollector.getPostTasksBoxed())
        previousSteps.append(step)
        return StepChainAssembly(previousSteps: previousSteps)
    }

    public func using<A: ContainerAction>(_ action: A) -> ContainerStepChainAssembly<A.ViewController, ViewController, Context> {
        var previousSteps = self.previousSteps
        let step = BaseStep<FactoryBox<FC>>(
                finder: self.finder,
                factory: self.factory,
                action: ContainerActionBox(action),
                interceptor: taskCollector.getInterceptorsBoxed(),
                contextTask: taskCollector.getContextTasksBoxed(),
                postTask: taskCollector.getPostTasksBoxed())
        previousSteps.append(step)
        return ContainerStepChainAssembly(previousSteps: previousSteps)
    }

}

public extension StepAssembly where FC: NilEntity {

    /// Connects previously provided `ActionToStepIntegrator` with `NilEntity` factory with a step where the `UIViewController`
    /// should avoid type checks
    /// Example: `UIViewController` instance was loaded as a part of the stack inside of the storyboard.
    ///
    /// - Parameter step: `ActionToStepIntegrator` instance to be used.
    public func from<AF: Finder, AFC: AbstractFactory>(_ step: ActionToStepIntegrator<AF, AFC>) -> ActionConnectingAssembly<AF, AFC, ViewController, Context>
            where AF.Context == Context {
        var previousSteps = self.previousSteps
        let currentStep = BaseStep<FactoryBox<FC>>(
                finder: self.finder,
                factory: self.factory,
                action: ActionBox(ViewControllerActions.NilAction()),
                interceptor: taskCollector.getInterceptorsBoxed(),
                contextTask: taskCollector.getContextTasksBoxed(),
                postTask: taskCollector.getPostTasksBoxed())
        previousSteps.append(currentStep)
        return ActionConnectingAssembly(stepToFullFill: step, previousSteps: previousSteps)
    }

    /// Connects previously provided `DestinationStep` with `NilEntity` factory with a step where the `UIViewController`
    /// should avoid type checks
    /// Example: `UIViewController` instance was loaded as a part of the stack inside of the storyboard.
    ///
    /// - Parameter step: `DestinationStep` instance to be used.
    public func from<VC: UIViewController>(_ step: DestinationStep<VC, Context>) -> LastStepInChainAssembly<ViewController, Context> {
        var previousSteps = self.previousSteps
        let currentStep = BaseStep<FactoryBox<FC>>(
                finder: self.finder,
                factory: self.factory,
                action: ActionBox(ViewControllerActions.NilAction()),
                interceptor: taskCollector.getInterceptorsBoxed(),
                contextTask: taskCollector.getContextTasksBoxed(),
                postTask: taskCollector.getPostTasksBoxed())
        previousSteps.append(currentStep)
        previousSteps.append(step)
        return LastStepInChainAssembly(previousSteps: previousSteps)
    }

}
