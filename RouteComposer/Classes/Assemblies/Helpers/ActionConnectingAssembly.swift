//
// RouteComposer
// ActionConnectingAssembly.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2025.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import UIKit

/// Helper class to build a chain of steps. Can not be used directly.
@MainActor
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
    @_disfavoredOverload
    public func using(_ action: some Action) -> StepChainAssembly<VC, C> {
        usingAction(action)
    }

    @_spi(Internals)
    public func usingAction(_ action: some Action) -> StepChainAssembly<VC, C> {
        var previousSteps = previousSteps
        if let routingStep = stepToFullFill.routingStep(with: action) {
            previousSteps.append(routingStep)
        }
        return StepChainAssembly(previousSteps: previousSteps)
    }

    /// Connects previously provided step instance with an `Action`
    ///
    /// - Parameter action: `Action` instance to be used with a step.
    /// - Returns: `ChainAssembly` to continue building the chain.
    @_disfavoredOverload
    public func using<A: ContainerAction>(_ action: A) -> ContainerStepChainAssembly<A.ViewController, VC, C> {
        usingAction(action)
    }

    @_spi(Internals)
    public func usingAction<A: ContainerAction>(_ action: A) -> ContainerStepChainAssembly<A.ViewController, VC, C> {
        var previousSteps = previousSteps
        if let routingStep = stepToFullFill.embeddableRoutingStep(with: action) {
            previousSteps.append(routingStep)
        }
        return ContainerStepChainAssembly(previousSteps: previousSteps)
    }

}

// MARK: - Shorthand overloads to enable `.using(.present(...))` and others

extension ActionConnectingAssembly {
    /// Enables shorthand `.using(.present(...))` by providing a concrete expected type.
    public func using(_ action: ViewControllerActions.PresentModallyAction) -> StepChainAssembly<VC, C> {
        usingAction(action)
    }

    /// Enables shorthand `.using(.replaceRoot(...))`
    public func using(_ action: ViewControllerActions.ReplaceRootAction) -> StepChainAssembly<VC, C> {
        usingAction(action)
    }

    /// Enables shorthand `.using(.nilAction)`
    public func using(_ action: ViewControllerActions.NilAction) -> StepChainAssembly<VC, C> {
        usingAction(action)
    }

    /// Enables shorthand `.using(.push)`
    public func using(_ action: NavigationControllerActions.PushAction<UINavigationController>) -> ContainerStepChainAssembly<UINavigationController, VC, C> {
        usingAction(action)
    }

    /// Enables shorthand `.using(.pushAsRoot)`
    public func using(_ action: NavigationControllerActions.PushAsRootAction<UINavigationController>) -> ContainerStepChainAssembly<UINavigationController, VC, C> {
        usingAction(action)
    }

    /// Enables shorthand `.using(.pushReplacingLast)`
    public func using(_ action: NavigationControllerActions.PushReplacingLastAction<UINavigationController>) -> ContainerStepChainAssembly<UINavigationController, VC, C> {
        usingAction(action)
    }
}


