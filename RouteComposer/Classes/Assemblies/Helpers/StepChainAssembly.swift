//
// Created by Eugene Kazaev on 11/09/2018.
//

import Foundation
import UIKit

/// Helper class to build a chain of steps. Can not be used directly.
public struct StepChainAssembly<ViewController: UIViewController, Context> {

    // MARK: Properties

    let previousSteps: [RoutingStep]

    // MARK: Methods

    init(previousSteps: [RoutingStep]) {
        self.previousSteps = previousSteps
    }

    /// Adds a single step to the chain
    ///
    /// - Parameter previousStep: The instance of `StepWithActionAssemblable`
    public func from<VC: UIViewController>(_ step: ActionToStepIntegrator<VC, Context>) -> ActionConnectingAssembly<VC, ViewController, Context> {
        return ActionConnectingAssembly<VC, ViewController, Context>(stepToFullFill: step, previousSteps: previousSteps)
    }

    /// Adds a `DestinationStep` to the chain. This step will be the last one in the chain.
    ///
    /// - Parameter previousStep: The instance of `DestinationStep`
    public func from<VC: UIViewController>(_ step: DestinationStep<VC, Context>) -> LastStepInChainAssembly<ViewController, Context> {
        var previousSteps = self.previousSteps
        previousSteps.append(step)
        return LastStepInChainAssembly<ViewController, Context>(previousSteps: previousSteps)
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
