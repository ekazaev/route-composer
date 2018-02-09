//
// Created by Eugene Kazaev on 07/02/2018.
//

import Foundation

public class StepChainAssembly {
    private var previousSteps: [RoutingStep] = []

    public init(from previousStep: RoutingStep) {
        self.previousSteps.append(previousStep)
    }

    public func from(_ previousStep: RoutingStep) -> StepChainAssembly {
        self.previousSteps.append(previousStep)
        return self
    }

    public func assemble() -> RoutingStep {
        return chain(previousSteps)
    }
}

/// Connects array of steps into a chain of steps.
///
/// - parameter chains: Array of chainable steps.
/// - returns: Last step to be made by a Router. The rest are linked to the last one.
func chain(_ steps: [RoutingStep]) -> RoutingStep {
    guard let firstStep = steps.first else {
        fatalError("No steps provided to chain.")
    }

    var restSteps = steps
    var currentStep = firstStep
    restSteps.removeFirst()

    for presentingStep in restSteps {
        guard let step = currentStep as? ChainableStep else {
            fatalError("\(presentingStep) can not be chained to non chainable step \(currentStep)")
        }
        step.from(presentingStep)
        currentStep = presentingStep
    }

    return firstStep
}