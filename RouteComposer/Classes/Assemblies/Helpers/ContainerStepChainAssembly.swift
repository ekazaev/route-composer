//
// RouteComposer
// ContainerStepChainAssembly.swift
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

/// Helper class to build a chain of steps. Can not be used directly.
public struct ContainerStepChainAssembly<AcceptableContainer: ContainerViewController, ViewController: UIViewController, Context> {

    // MARK: Properties

    let previousSteps: [RoutingStep]

    // MARK: Methods

    init(previousSteps: [RoutingStep]) {
        self.previousSteps = previousSteps
    }

    /// Adds a single step to the chain
    ///
    /// - Parameter previousStep: The instance of `StepWithActionAssemblable`
    public func from(_ step: ActionToStepIntegrator<AcceptableContainer, Context>) -> ActionConnectingAssembly<ViewController, Context> {
        ActionConnectingAssembly<ViewController, Context>(stepToFullFill: step, previousSteps: previousSteps)
    }

    /// Adds a `DestinationStep` to the chain. This step will be the last one in the chain.
    ///
    /// - Parameter previousStep: The instance of `DestinationStep`
    public func from(_ step: DestinationStep<AcceptableContainer, Context>) -> LastStepInChainAssembly<ViewController, Context> {
        var previousSteps = previousSteps
        previousSteps.append(step)
        return LastStepInChainAssembly(previousSteps: previousSteps)
    }

    /// Assembles all the provided settings.
    ///
    /// - Parameter step: An instance of `DestinationStep` to build a current stack from.
    /// - Returns: An instance of `DestinationStep` with all the provided settings inside.
    public func assemble(from step: DestinationStep<AcceptableContainer, Context>) -> DestinationStep<ViewController, Context> {
        var previousSteps = previousSteps
        previousSteps.append(step)
        return LastStepInChainAssembly(previousSteps: previousSteps).assemble()
    }

}
