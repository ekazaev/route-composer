//
// Created by Eugene Kazaev on 2018-09-17.
//

import Foundation

/// Represents a single step for the `Router` to make.
public struct DestinationStep<C>: RoutingStepWithContext, ChainableStep, PerformableStep {

    /// Type of the `Context` associated with the step
    public typealias Context = C

    var previousStep: RoutingStep? {
        return destinationStep
    }

    let destinationStep: RoutingStep

    init(_ destinationStep: RoutingStep) {
        self.destinationStep = destinationStep
    }

    func perform(for context: Any?) -> StepResult {
        return .continueRouting(nil)
    }

    /// Removes context type dependency from a step.
    public func unsafelyUnwrapped() -> DestinationStep<Any?> {
        return DestinationStep<Any?>(destinationStep)
    }

}
