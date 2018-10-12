//
// Created by Eugene Kazaev on 11/09/2018.
//

import Foundation
import UIKit

/// Helper class to build a chain of steps. Can not be used directly.
public struct StepChainAssembly<ViewController: UIViewController, Context> {

    let previousSteps: [RoutingStep]

    init(previousSteps: [RoutingStep]) {
        self.previousSteps = previousSteps
    }

    /// Adds a single step to the chain
    ///
    /// - Parameter previousStep: The instance of `StepWithActionAssemblable`
    public func from<F: Finder, FC: AbstractFactory>(_ step: StepWithActionAssembly<F, FC>) -> ActionConnectingAssembly<F, FC, ViewController, Context>
            where F.ViewController == FC.ViewController, F.Context == FC.Context, F.Context == Context {
        return ActionConnectingAssembly<F, FC, ViewController, Context>(stepToFullFill: step, previousSteps: previousSteps)
    }

    /// Adds a `DestinationStep` to the chain. This step will be the last one in the chain.
    ///
    /// - Parameter previousStep: The instance of `DestinationStep`
    public func from<VC: UIViewController>(_ step: DestinationStep<VC, Context>) -> LastStepInChainAssembly<ViewController, Context> {
        var previousSteps = self.previousSteps
        previousSteps.append(step)
        return LastStepInChainAssembly<ViewController, Context>(previousSteps: previousSteps)
    }

    /// Connects previously provided `DestinationStep` with a `ViewController` produced by an empty factory.
    ///
    /// - Parameter step: `StepWithActionAssembly` instance to be used.
    public func from<F: Finder, FC: AbstractFactory & NilEntity>(_ step: StepWithActionAssembly<F, FC>) -> StepChainAssembly<ViewController, Context>
            where F.ViewController == FC.ViewController, F.Context == FC.Context, F.Context == Context {
        var previousSteps = self.previousSteps
        previousSteps.append(step.routingStep(with: ViewControllerActions.NilAction()))
        return StepChainAssembly(previousSteps: previousSteps)
    }

    /// Assembles all the provided settings.
    ///
    /// - Parameter step: An instance of `DestinationStep` to start to build a current step from.
    /// - Returns: An instance of `DestinationStep` with all the provided settings inside.
    public func assemble<VC: UIViewController>(from step: DestinationStep<VC, Context>) -> DestinationStep<ViewController, Context> {
        var previousSteps = self.previousSteps
        previousSteps.append(step)
        return LastStepInChainAssembly<ViewController, Context>(previousSteps: previousSteps).assemble()
    }

}

/// Helper class to build a chain of steps. Can not be used directly.
public struct ContainerStepChainAssembly<AcceptableContainer: ContainerViewController, ViewController: UIViewController, Context> {

    let previousSteps: [RoutingStep]

    init(previousSteps: [RoutingStep]) {
        self.previousSteps = previousSteps
    }

    /// Adds a single step to the chain
    ///
    /// - Parameter previousStep: The instance of `StepWithActionAssemblable`
    public func from<F: Finder, FC: AbstractFactory>(_ step: StepWithActionAssembly<F, FC>) -> ActionConnectingAssembly<F, FC, ViewController, Context>
            where F.ViewController == FC.ViewController, F.Context == FC.Context, F.ViewController == AcceptableContainer, F.Context == Context {
        return ActionConnectingAssembly<F, FC, ViewController, Context>(stepToFullFill: step, previousSteps: previousSteps)
    }

    /// Connects previously provided `DestinationStep` with a `ViewController` produced by an empty factory.
    ///
    /// - Parameter step: `StepWithActionAssembly` instance to be used.
    public func from<F: Finder, FC: AbstractFactory & NilEntity>(_ step: StepWithActionAssembly<F, FC>) -> StepChainAssembly<ViewController, Context> where F.Context == Context {
        var previousSteps = self.previousSteps
        previousSteps.append(step.routingStep(with: ViewControllerActions.NilAction()))
        return StepChainAssembly(previousSteps: previousSteps)
    }

    /// Adds a `DestinationStep` to the chain. This step will be the last one in the chain.
    ///
    /// - Parameter previousStep: The instance of `DestinationStep`
    public func from(_ step: DestinationStep<AcceptableContainer, Context>) -> LastStepInChainAssembly<ViewController, Context> {
        var previousSteps = self.previousSteps
        previousSteps.append(step)
        return LastStepInChainAssembly(previousSteps: previousSteps)
    }

    /// Assembles all the provided settings.
    ///
    /// - Parameter step: An instance of `DestinationStep` to build a current stack from.
    /// - Returns: An instance of `DestinationStep` with all the provided settings inside.
    public func assemble(from step: DestinationStep<AcceptableContainer, Context>) -> DestinationStep<ViewController, Context> {
        var previousSteps = self.previousSteps
        previousSteps.append(step)
        return LastStepInChainAssembly(previousSteps: previousSteps).assemble()
    }

    // MARK: - The method allow avoiding required view controller type checks.

    /// Connects previously provided `DestinationStep` with `ContainerViewController` factory with a step where the `UIViewController`
    /// should be to avoid a container view controller type check.
    ///
    /// - Parameter step: `StepWithActionAssembly` instance to be used.
    public func from1<F: Finder, FC: AbstractFactory>(_ step: StepWithActionAssembly<F, FC>) -> ActionConnectingAssembly<F, FC, ViewController, Context>
            where F.ViewController == FC.ViewController, F.Context == FC.Context, F.Context == Context {
        return ActionConnectingAssembly(stepToFullFill: step, previousSteps: previousSteps)
    }

}
