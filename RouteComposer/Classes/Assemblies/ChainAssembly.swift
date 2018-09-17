//
// Created by Eugene Kazaev on 07/02/2018.
//

import Foundation
import UIKit

/// Connects an array of steps into a chain of steps.
public struct ChainAssembly {

    /// Connects step into a chain of steps.
    /// ### Usage
    /// ```swift
    /// let intermediateStep = ChainAssembly(from: NavigationControllerStep())
    ///         .from(using: DefaultActions.PresentModally())
    ///         .from(CurrentViewControllerStep())
    ///         .assemble()
    /// ```
    /// - Parameter step: The instance of `StepWithActionAssembly`
    public static func from<F: Finder, FC: AbstractFactory>(_ step: StepWithActionAssembly<F, FC>) -> ActionConnectingAssembly<F, FC, F.Context> {
        return ActionConnectingAssembly(stepToFullFill: step, previousSteps: [])
    }

    /// Connects step into a chain of steps.
    /// ### Usage
    /// ```swift
    /// let intermediateStep = ChainAssembly(from: previousSteps)
    ///         .assemble()
    /// ```
    /// - Parameter step: The instance of `RoutingStep`
    public static func from<C>(_ step: DestinationStep<C>) -> LastStepInChainAssembly<C> {
        return LastStepInChainAssembly(previousSteps: [step])
    }

}
