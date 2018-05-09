//
// Created by Eugene Kazaev on 05/02/2018.
//

import Foundation
import UIKit

/// the case resolver for `SwitcherStep`
public protocol StepCaseResolver {

    /// THE Method to be called by a `SwitcherStep` at the moment when it will try to find a previous step for the `Router`.
    ///
    /// - Parameter destination: A `RoutingDestination` instance that been passed to the `Router`
    /// - Returns: A `RoutingStep` to be made by `Router`, nil if resolver could not decide when step should be previous
    func resolve<D: RoutingDestination>(for destination: D) -> RoutingStep?

}

class SwitcherStep: RoutingStep, ChainableStep, PerformableStep {

    private(set) public var previousStep: RoutingStep? = nil

    private var resolvers: [StepCaseResolver]

    func perform<D: RoutingDestination>(for destination: D) -> StepResult {
        previousStep = nil
        resolvers.forEach({ resolver in
            guard previousStep == nil, let step = resolver.resolve(for: destination) else {
                return
            }
            previousStep = step
        })

        guard let _ = previousStep else {
            return .failure
        }
        return .continueRouting(nil)
    }

    public init(resolvers: [StepCaseResolver]) {
        self.resolvers = resolvers
    }
}
