//
// Created by Eugene Kazaev on 07/02/2018.
//

import Foundation

/// Connects an array of steps into a chain of steps.
/// ### Usage
/// ```swift
/// let intermediateStep = ChainAssembly()
///         .from(NavigationControllerStep(action: DefaultActions.PresentModally()))
///         .from(CurrentViewControllerStep())
///         .assemble()
/// ```
public struct ChainAssembly {

    let previousSteps: [RoutingStep]

    /// Constructor
    public init() {
        self.previousSteps = []
    }

    init(previousSteps: [RoutingStep]) {
        self.previousSteps = previousSteps
    }

    /// A previous step to start build a current step from
    ///
    /// - Parameter previousStep: The instance of `RoutingStep` and `ChainingStep`
    public func from(_ step: RoutingStep & ChainingStep) -> ScreenStepChainAssembly {
        var previousSteps = self.previousSteps
        previousSteps.append(step)
        return ScreenStepChainAssembly(previousSteps: previousSteps)
    }

    /// A single step to start build a current step from
    ///
    /// - Parameter previousStep: The instance of `StepWithActionAssemblable`
    public func from<F: Finder, FC: AbstractFactory>(_ step: StepWithActionAssembly<F,FC>) -> TypedScreenStepChainAssembly<F, FC>
            where F.ViewController == FC.ViewController, F.Context == FC.Context {
        return TypedScreenStepChainAssembly(stepToFullFill: step, previousSteps: previousSteps)
    }

    /// A Previous `RoutingStep` to start build a current step from
    ///
    /// - Parameter previousStep: The instance of `RoutingStep`
    public func from(_ step: RoutingStep) -> LastStepInChainAssembly {
        var previousSteps = self.previousSteps
        previousSteps.append(step)
        return LastStepInChainAssembly(previousSteps: previousSteps)
    }

    /// Assemble all the provided settings.
    ///
    /// - Parameter step: An instance of `RoutingStep` to start to build a current step from.
    /// - Returns: An instance of `RoutingStep` with all the provided settings inside.
    public func assemble(from step: RoutingStep) -> RoutingStep {
        var previousSteps = self.previousSteps
        previousSteps.append(step)
        return LastStepInChainAssembly(previousSteps: previousSteps).assemble()
    }

}

func chain(_ steps: [RoutingStep]) -> RoutingStep {
    guard let firstStep = steps.first else {
        fatalError("No steps provided to chain.")
    }

    var restSteps = steps
    var currentStep = firstStep
    restSteps.removeFirst()

    for presentingStep in restSteps {
        guard let step = currentStep as? ChainingStep else {
            assertionFailure("\(presentingStep) can not be chained to non chainable step \(currentStep)")
            return firstStep
        }
        if let chainableStep = step as? ChainableStep, let previousStep = chainableStep.previousStep {
            assertionFailure("\(currentStep) is already chained to  \(previousStep)")
            return firstStep
        }
        step.from(presentingStep)
        currentStep = presentingStep
    }

    return firstStep
}
