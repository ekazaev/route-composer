//
// Created by Eugene Kazaev on 07/02/2018.
//

import Foundation
import UIKit

/// Connects an array of steps into a chain of steps.
/// ### Usage
/// ```swift
/// let intermediateStep = ChainAssembly()
///         .from(NavigationControllerStep(action: DefaultActions.PresentModally()))
///         .from(CurrentViewControllerStep())
///         .assemble()
/// ```
/// - Parameter step: The instance of `StepWithActionAssembly`
public func ChainAssembly<F: Finder, FC: AbstractFactory>(from step: StepWithActionAssembly<F, FC>) -> ActionConnectingAssembly<F, FC> {
    return ActionConnectingAssembly(stepToFullFill: step, previousSteps: [])
}

/// Connects an array of steps into a chain of steps.
/// ### Usage
/// ```swift
/// let intermediateStep = ChainAssembly()
///         .from(NavigationControllerStep(action: DefaultActions.PresentModally()))
///         .from(CurrentViewControllerStep())
///         .assemble()
/// ```
/// - Parameter step: The instance of `RoutingStep`
public func ChainAssembly(from step: RoutingStep) -> LastStepInChainAssembly {
    return LastStepInChainAssembly(previousSteps: [step])
}