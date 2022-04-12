//
// RouteComposer
// ActionConnectingAssembly.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
//

import Foundation
import UIKit

/// Helper class to build a chain of steps. Can not be used directly.
public struct ActionConnectingAssembly<VC: UIViewController, C> {

    // MARK: Properties

    let previousSteps: [RoutingStep]

    let stepToFullFill: IntermediateDestinationStep

    // MARK: Methods

    init(stepToFullFill: IntermediateDestinationStep, previousSteps: [RoutingStep] = []) {
        self.previousSteps = previousSteps
        self.stepToFullFill = stepToFullFill
    }

    /// Connects previously provided step instance with an `Action`
    ///
    /// - Parameter action: `Action` instance to be used with a step.
    /// - Returns: `ChainAssembly` to continue building the chain.
    public func using<A: Action>(_ action: A) -> StepChainAssembly<VC, C> {
        var previousSteps = self.previousSteps
        if let routingStep = stepToFullFill.routingStep(with: action) {
            previousSteps.append(routingStep)
        }
        return StepChainAssembly(previousSteps: previousSteps)
    }

    /// Connects previously provided step instance with an `Action`
    ///
    /// - Parameter action: `Action` instance to be used with a step.
    /// - Returns: `ChainAssembly` to continue building the chain.
    public func using<A: ContainerAction>(_ action: A) -> ContainerStepChainAssembly<A.ViewController, VC, C> {
        var previousSteps = self.previousSteps
        if let routingStep = stepToFullFill.embeddableRoutingStep(with: action) {
            previousSteps.append(routingStep)
        }
        return ContainerStepChainAssembly(previousSteps: previousSteps)
    }

}
