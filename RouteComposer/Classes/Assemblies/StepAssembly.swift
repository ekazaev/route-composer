//
// RouteComposer
// StepAssembly.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
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

    private init(finder: F, abstractFactory: FC) {
        self.factory = abstractFactory
        self.finder = finder
        self.previousSteps = []
    }

}

// MARK: Methods for Factory

public extension StepAssembly where FC: Factory {

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
    final func using(_ action: some Action) -> StepChainAssembly<ViewController, Context> {
        var previousSteps = previousSteps
        let entitiesCollector = BaseEntitiesCollector<FactoryBox<FC>, ActionBox>(finder: finder, factory: factory, action: action)
        let step = BaseStep(entitiesProvider: entitiesCollector, taskProvider: taskCollector)
        previousSteps.append(step)
        return StepChainAssembly(previousSteps: previousSteps)
    }

    /// Connects previously provided `DestinationStep` instance with an `Action`
    ///
    /// - Parameter action: `ContainerAction` instance to be used with a step.
    final func using<A: ContainerAction>(_ action: A) -> ContainerStepChainAssembly<A.ViewController, ViewController, Context> {
        var previousSteps = previousSteps
        let entitiesCollector = BaseEntitiesCollector<FactoryBox<FC>, ContainerActionBox>(finder: finder, factory: factory, action: action)
        let step = BaseStep(entitiesProvider: entitiesCollector, taskProvider: taskCollector)
        previousSteps.append(step)
        return ContainerStepChainAssembly(previousSteps: previousSteps)
    }

}

// MARK: Methods for ContainerFactory

public extension StepAssembly where FC: ContainerFactory {

    /// Constructor
    ///
    /// - Parameters:
    ///   - finder: The `UIViewController` `Finder` instance.
    ///   - factory: The `UIViewController` `ContainerFactory` instance.
    convenience init(finder: F, factory: FC) {
        self.init(finder: finder, abstractFactory: factory)
    }

    /// Connects previously provided `DestinationStep` instance with an `Action`
    ///
    /// - Parameter action: `Action` instance to be used with a step.
    final func using(_ action: some Action) -> StepChainAssembly<ViewController, Context> {
        var previousSteps = previousSteps
        let entitiesCollector = BaseEntitiesCollector<ContainerFactoryBox<FC>, ActionBox>(finder: finder, factory: factory, action: action)
        let step = BaseStep(entitiesProvider: entitiesCollector, taskProvider: taskCollector)
        previousSteps.append(step)
        return StepChainAssembly(previousSteps: previousSteps)
    }

    /// Connects previously provided `DestinationStep` instance with an `Action`
    ///
    /// - Parameter action: `ContainerAction` instance to be used with a step.
    final func using<A: ContainerAction>(_ action: A) -> ContainerStepChainAssembly<A.ViewController, ViewController, Context> {
        var previousSteps = previousSteps
        let entitiesCollector = BaseEntitiesCollector<ContainerFactoryBox<FC>, ContainerActionBox>(finder: finder, factory: factory, action: action)
        let step = BaseStep(entitiesProvider: entitiesCollector, taskProvider: taskCollector)
        previousSteps.append(step)
        return ContainerStepChainAssembly(previousSteps: previousSteps)
    }
}

// MARK: Methods for the Nil Factory

public extension StepAssembly where FC: Factory & NilEntity {

    /// Connects previously provided `ActionToStepIntegrator` with `NilEntity` factory with a step where the `UIViewController`
    /// should avoid type checks
    /// Example: `UIViewController` instance was loaded as a part of the stack inside of the storyboard.
    ///
    /// - Parameter step: `ActionToStepIntegrator` instance to be used.
    final func from(_ step: ActionToStepIntegrator<some UIViewController, Context>) -> ActionConnectingAssembly<ViewController, Context> {
        var previousSteps = previousSteps
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
    final func from(_ step: DestinationStep<some UIViewController, Context>) -> LastStepInChainAssembly<ViewController, Context> {
        var previousSteps = previousSteps
        let entitiesCollector = BaseEntitiesCollector<FactoryBox<FC>, ActionBox>(finder: finder, factory: factory, action: ViewControllerActions.NilAction())
        let currentStep = BaseStep(entitiesProvider: entitiesCollector, taskProvider: taskCollector)
        previousSteps.append(currentStep)
        previousSteps.append(step)
        return LastStepInChainAssembly(previousSteps: previousSteps)
    }

}

// MARK: Methods for the Nil ConatinerFactory

public extension StepAssembly where FC: ContainerFactory & NilEntity {

    /// Connects previously provided `ActionToStepIntegrator` with `NilEntity` factory with a step where the `UIViewController`
    /// should avoid type checks.
    ///
    /// - Parameter step: `ActionToStepIntegrator` instance to be used.
    final func from(_ step: ActionToStepIntegrator<some UIViewController, Context>) -> ActionConnectingAssembly<ViewController, Context> {
        var previousSteps = previousSteps
        let entitiesCollector = BaseEntitiesCollector<ContainerFactoryBox<FC>, ActionBox>(finder: finder, factory: factory, action: ViewControllerActions.NilAction())
        let currentStep = BaseStep(entitiesProvider: entitiesCollector, taskProvider: taskCollector)
        previousSteps.append(currentStep)
        return ActionConnectingAssembly(stepToFullFill: step, previousSteps: previousSteps)
    }

    /// Connects previously provided `DestinationStep` with `NilEntity` factory with a step where the `UIViewController`
    /// should avoid type checks
    ///
    /// - Parameter step: `DestinationStep` instance to be used.
    final func from(_ step: DestinationStep<some UIViewController, Context>) -> LastStepInChainAssembly<ViewController, Context> {
        var previousSteps = previousSteps
        let entitiesCollector = BaseEntitiesCollector<ContainerFactoryBox<FC>, ActionBox>(finder: finder, factory: factory, action: ViewControllerActions.NilAction())
        let currentStep = BaseStep(entitiesProvider: entitiesCollector, taskProvider: taskCollector)
        previousSteps.append(currentStep)
        previousSteps.append(step)
        return LastStepInChainAssembly(previousSteps: previousSteps)
    }

}
