//
// Created by Eugene Kazaev on 07/02/2018.
//

import Foundation
import UIKit

/// Builds a chain of steps.
public struct ChainAssembly {

    /// Transforms step into a chain of steps.
    /// ### Usage
    /// ```swift
    /// let intermediateStep = ChainAssembly(from: NavigationControllerStep())
    ///         .from(using: DefaultActions.PresentModally())
    ///         .from(CurrentViewControllerStep())
    ///         .assemble()
    /// ```
    /// - Parameter step: The instance of `ActionConnectingAssembly`
    public static func from<F: Finder, FC: AbstractFactory>(_ step: StepWithActionAssembly<F, FC>) -> ActionConnectingAssembly<F, FC, F.ViewController, F.Context> {
        return ActionConnectingAssembly(stepToFullFill: step, previousSteps: [])
    }

    /// Transforms step into a chain of steps.
    /// ### Usage
    /// ```swift
    /// let intermediateStep = ChainAssembly(from: previousSteps)
    ///         .assemble()
    /// ```
    /// - Parameter step: The instance of `LastStepInChainAssembly`
    public static func from<VC, C>(_ step: DestinationStep<VC, C>) -> LastStepInChainAssembly<VC, C> {
        return LastStepInChainAssembly(previousSteps: [step])
    }

}
