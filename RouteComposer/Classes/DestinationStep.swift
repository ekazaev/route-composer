//
// Created by Eugene Kazaev on 2018-09-17.
//

import Foundation

/// Represents a single step for the `Router` to make.
public struct DestinationStep<C>: RoutingStepWithContext, ChainableStep, PerformableStep {

    public typealias Context = C

    var previousStep: RoutingStep? {
        return destinationStep
    }

    let destinationStep: RoutingStep

    init(_ destinationStep: RoutingStep) {
        self.destinationStep = destinationStep
    }

    func perform(for destination: Any?) -> StepResult {
        return .continueRouting(nil)
    }

    // Removes context type dependency from a step.
    public func unsafelyUnwrapped() -> DestinationStep<Any?> {
        return DestinationStep<Any?>(destinationStep)
    }

}
