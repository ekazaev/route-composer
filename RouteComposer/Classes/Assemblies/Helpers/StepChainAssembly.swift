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
            where F.ViewController == FC.ViewController, F.Context == FC.Context {
        return ActionConnectingAssembly<F, FC, ViewController, Context>(stepToFullFill: step, previousSteps: previousSteps)
    }

    /// Adds a `DestinationStep` to the chain. This step will be the last one in the chain.
    ///
    /// - Parameter previousStep: The instance of `DestinationStep`
    public func from<AVC: UIViewController, AC>(_ step: DestinationStep<AVC, AC>) -> LastStepInChainAssembly<ViewController, Context> {
        var previousSteps = self.previousSteps
        previousSteps.append(step)
        return LastStepInChainAssembly<ViewController, Context>(previousSteps: previousSteps)
    }

    /// Connects previously provided `DestinationStep` with a `ViewController` produced by an empty factory.
    ///
    /// - Parameter step: `StepWithActionAssembly` instance to be used.
    public func from<AF: Finder, AFC: AbstractFactory & NilEntity>(_ step: StepWithActionAssembly<AF, AFC>) -> StepChainAssembly<ViewController, Context> {
        var previousSteps = self.previousSteps
        previousSteps.append(step.routingStep(with: UIViewController.NilAction()))
        return StepChainAssembly(previousSteps: previousSteps)
    }

    /// Assembles all the provided settings.
    ///
    /// - Parameter step: An instance of `DestinationStep` to start to build a current step from.
    /// - Returns: An instance of `DestinationStep` with all the provided settings inside.
    public func assemble<AVC: UIViewController, AC>(from step: DestinationStep<AVC, AC>) -> DestinationStep<ViewController, Context> {
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
            where F.ViewController == FC.ViewController, F.Context == FC.Context, F.ViewController == AcceptableContainer {
        return ActionConnectingAssembly<F, FC, ViewController, Context>(stepToFullFill: step, previousSteps: previousSteps)
    }

    /// Connects previously provided `DestinationStep` with a `ViewController` produced by an empty factory.
    ///
    /// - Parameter step: `StepWithActionAssembly` instance to be used.
    public func from<AF: Finder, AFC: AbstractFactory & NilEntity>(_ step: StepWithActionAssembly<AF, AFC>) -> StepChainAssembly<ViewController, Context> {
        var previousSteps = self.previousSteps
        previousSteps.append(step.routingStep(with: UIViewController.NilAction()))
        return StepChainAssembly(previousSteps: previousSteps)
    }

    /// Adds a `DestinationStep` to the chain. This step will be the last one in the chain.
    ///
    /// - Parameter previousStep: The instance of `DestinationStep`
    public func from<AC>(_ step: DestinationStep<AcceptableContainer, AC>) -> LastStepInChainAssembly<ViewController, Context> {
        var previousSteps = self.previousSteps
        previousSteps.append(step)
        return LastStepInChainAssembly(previousSteps: previousSteps)
    }

    /// Assembles all the provided settings.
    ///
    /// - Parameter step: An instance of `DestinationStep` to build a current stack from.
    /// - Returns: An instance of `DestinationStep` with all the provided settings inside.
    public func assemble<AC>(from step: DestinationStep<AcceptableContainer, AC>) -> DestinationStep<ViewController, Context> {
        var previousSteps = self.previousSteps
        previousSteps.append(step)
        return LastStepInChainAssembly(previousSteps: previousSteps).assemble()
    }

    // MARK: - The methods below allow avoiding required view controller type checks

    /// Connects previously provided `DestinationStep` with `ContainerViewController` factory with a step where the `UIViewController`
    /// should be to avoid type checks.
    ///
    /// - Parameter step: `StepWithActionAssembly` instance to be used.
    public func within<AF: Finder, AFC: AbstractFactory>(_ step: StepWithActionAssembly<AF, AFC>) -> ActionConnectingAssembly<AF, AFC, ViewController, Context> {
        return ActionConnectingAssembly(stepToFullFill: step, previousSteps: previousSteps)
    }

    /// Connects previously provided `DestinationStep` with `ContainerViewController` factory with a step where the `UIViewController`
    /// should be to avoid type checks.
    ///
    /// - Parameter step: `DestinationStep` instance to be used.
    public func within<AVC: UIViewController, AC>(_ step: DestinationStep<AVC, AC>) -> LastStepInChainAssembly<ViewController, Context> {
        var previousSteps = self.previousSteps
        previousSteps.append(step)
        return LastStepInChainAssembly(previousSteps: previousSteps)
    }

    /// Assembles all the provided settings.
    ///
    /// - Parameter step: An instance of `DestinationStep` to build a current step from.
    /// - Returns: An instance of `DestinationStep` with all the provided settings inside.
    public func assemble<AVC: UIViewController, AC>(within step: DestinationStep<AVC, AC>) -> DestinationStep<ViewController, Context> {
        var previousSteps = self.previousSteps
        previousSteps.append(step)
        return LastStepInChainAssembly(previousSteps: previousSteps).assemble()
    }

}
