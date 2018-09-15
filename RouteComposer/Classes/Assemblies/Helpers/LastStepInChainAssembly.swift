//
// Created by Eugene Kazaev on 31/08/2018.
//

import Foundation

/// Helper class to build a chain of steps. Can not be used directly.
public struct LastStepInChainAssembly<C> {

    let previousSteps: [RoutingStep]

    init(previousSteps: [RoutingStep]) {
        self.previousSteps = previousSteps
    }

    /// Assembles all the provided settings.
    ///
    /// - Returns: The instance of `RoutingStep` with all the settings provided inside.
    public func assemble() -> DestinationStep<C> {
        return DestinationStep(chain(previousSteps))
    }

    private func chain(_ steps: [RoutingStep]) -> RoutingStep {
        guard let lastStep = steps.last else {
            fatalError("No steps provided to chain.")
        }

        var restSteps = steps
        var currentStep = lastStep
        restSteps.removeLast()

        for presentingStep in restSteps.reversed() {
            guard var step = presentingStep as? ChainingStep & RoutingStep else {
                assertionFailure("\(presentingStep) can not be chained to non chainable step \(currentStep)")
                return currentStep
            }
            if let chainableStep = presentingStep as? ChainableStep, let previousStep = chainableStep.previousStep {
                assertionFailure("\(presentingStep) is already chained to  \(previousStep)")
                return currentStep
            }
            step.from(currentStep)
            currentStep = step
        }

        return currentStep
    }

}
