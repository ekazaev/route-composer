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
///         .adding(LoginInterceptor())
///         .adding(ProductViewControllerContextTask())
///         .adding(ProductViewControllerPostTask(analyticsManager: AnalyticsManager.sharedInstance))
///         .using(UINavigationController.push())
///         .from(NavigationControllerStep())
///         .using(GeneralAction.presentModally())
///         .from(GeneralStep.current())
///         .assemble()
/// ```
public final class StepAssembly<F: Finder, FC: AbstractFactory>: GenericStepAssembly<F.ViewController, FC.Context>
        where
        F.ViewController == FC.ViewController, F.Context == FC.Context {

    // MARK: Properties

    let finder: F

    let factory: FC

    let previousSteps: [RoutingStep]

    // MARK: Methods

    fileprivate init(finder: F, abstractFactory: FC) {
        self.factory = abstractFactory
        self.finder = finder
        self.previousSteps = []
    }

}

public extension StepAssembly where FC: Factory {

    /// Constructor
    ///
    /// - Parameters:
    ///   - finder: The `UIViewController` `Finder` instance.
    ///   - factory: The `UIViewController` `Factory` instance.
    convenience init(finder: F, factory: FC) {
        self.init(finder: finder, abstractFactory: factory)
    }

    final func using<A: Action>(_ action: A) -> StepChainAssembly<ViewController, Context> {
        var previousSteps = self.previousSteps
        let entitiesCollector = BaseEntitiesCollector<FactoryBox<FC>, ActionBox>(finder: finder, factory: factory, action: action)
        let step = BaseStep(entitiesProvider: entitiesCollector, taskProvider: taskCollector)
        previousSteps.append(step)
        return StepChainAssembly(previousSteps: previousSteps)
    }

    final func using<A: ContainerAction>(_ action: A) -> ContainerStepChainAssembly<A.ViewController, ViewController, Context> {
        var previousSteps = self.previousSteps
        let entitiesCollector = BaseEntitiesCollector<FactoryBox<FC>, ContainerActionBox>(finder: finder, factory: factory, action: action)
        let step = BaseStep(entitiesProvider: entitiesCollector, taskProvider: taskCollector)
        previousSteps.append(step)
        return ContainerStepChainAssembly(previousSteps: previousSteps)
    }

}

public extension StepAssembly where FC: ContainerFactory {

    /// Constructor
    ///
    /// - Parameters:
    ///   - finder: The `UIViewController` `Finder` instance.
    ///   - factory: The `UIViewController` `Factory` instance.
    convenience init(finder: F, factory: FC) {
        self.init(finder: finder, abstractFactory: factory)
    }

    /// Connects previously provided `DestinationStep` instance with an `Action`
    ///
    /// - Parameter action: `Action` instance to be used with a step.
    final func using<A: Action>(_ action: A) -> StepChainAssembly<ViewController, Context> {
        var previousSteps = self.previousSteps
        let entitiesCollector = BaseEntitiesCollector<ContainerFactoryBox<FC>, ActionBox>(finder: finder, factory: factory, action: action)
        let step = BaseStep(entitiesProvider: entitiesCollector, taskProvider: taskCollector)
        previousSteps.append(step)
        return StepChainAssembly(previousSteps: previousSteps)
    }

    /// Connects previously provided `DestinationStep` instance with an `Action`
    ///
    /// - Parameter action: `ContainerAction` instance to be used with a step.
    final func using<A: ContainerAction>(_ action: A) -> ContainerStepChainAssembly<A.ViewController, ViewController, Context> {
        var previousSteps = self.previousSteps
        let entitiesCollector = BaseEntitiesCollector<ContainerFactoryBox<FC>, ContainerActionBox>(finder: finder, factory: factory, action: action)
        let step = BaseStep(entitiesProvider: entitiesCollector, taskProvider: taskCollector)
        previousSteps.append(step)
        return ContainerStepChainAssembly(previousSteps: previousSteps)
    }
}

// MARK: Methods for the NilFactory

public extension StepAssembly where FC: Factory & NilEntity {

    /// Connects previously provided `ActionToStepIntegrator` with `NilEntity` factory with a step where the `UIViewController`
    /// should avoid type checks
    /// Example: `UIViewController` instance was loaded as a part of the stack inside of the storyboard.
    ///
    /// - Parameter step: `ActionToStepIntegrator` instance to be used.
    final func from<VC: UIViewController>(_ step: ActionToStepIntegrator<VC, Context>) -> ActionConnectingAssembly<ViewController, Context> {
        var previousSteps = self.previousSteps
        let entitiesCollector = BaseEntitiesCollector<FactoryBox<FC>, ActionBox>(finder: finder, factory: factory, action: ViewControllerActions.NilAction())
        let currentStep = BaseStep(entitiesProvider: entitiesCollector, taskProvider: taskCollector)
        previousSteps.append(currentStep)
        return ActionConnectingAssembly(stepToFullFill: step, previousSteps: previousSteps)
    }

    /// Connects previously provided `DestinationStep` with `NilEntity` factory with a step where the `UIViewController`
    /// should avoid type checks
    /// Example: `UIViewController` instance was loaded as a part of the stack inside of the storyboard.
    ///
    /// - Parameter step: `DestinationStep` instance to be used.
    final func from<VC: UIViewController>(_ step: DestinationStep<VC, Context>) -> LastStepInChainAssembly<ViewController, Context> {
        var previousSteps = self.previousSteps
        let entitiesCollector = BaseEntitiesCollector<FactoryBox<FC>, ActionBox>(finder: finder, factory: factory, action: ViewControllerActions.NilAction())
        let currentStep = BaseStep(entitiesProvider: entitiesCollector, taskProvider: taskCollector)
        previousSteps.append(currentStep)
        previousSteps.append(step)
        return LastStepInChainAssembly(previousSteps: previousSteps)
    }

}

// MARK: Methods for the NilFactory

public extension StepAssembly where FC: ContainerFactory & NilEntity {

    /// Connects previously provided `ActionToStepIntegrator` with `NilEntity` factory with a step where the `UIViewController`
    /// should avoid type checks.
    ///
    /// - Parameter step: `ActionToStepIntegrator` instance to be used.
    final func from<VC: UIViewController>(_ step: ActionToStepIntegrator<VC, Context>) -> ActionConnectingAssembly<ViewController, Context> {
        var previousSteps = self.previousSteps
        let entitiesCollector = BaseEntitiesCollector<ContainerFactoryBox<FC>, ActionBox>(finder: finder, factory: factory, action: ViewControllerActions.NilAction())
        let currentStep = BaseStep(entitiesProvider: entitiesCollector, taskProvider: taskCollector)
        previousSteps.append(currentStep)
        return ActionConnectingAssembly(stepToFullFill: step, previousSteps: previousSteps)
    }

    /// Connects previously provided `DestinationStep` with `NilEntity` factory with a step where the `UIViewController`
    /// should avoid type checks
    ///
    /// - Parameter step: `DestinationStep` instance to be used.
    final func from<VC: UIViewController>(_ step: DestinationStep<VC, Context>) -> LastStepInChainAssembly<ViewController, Context> {
        var previousSteps = self.previousSteps
        let entitiesCollector = BaseEntitiesCollector<ContainerFactoryBox<FC>, ActionBox>(finder: finder, factory: factory, action: ViewControllerActions.NilAction())
        let currentStep = BaseStep(entitiesProvider: entitiesCollector, taskProvider: taskCollector)
        previousSteps.append(currentStep)
        previousSteps.append(step)
        return LastStepInChainAssembly(previousSteps: previousSteps)
    }

}
