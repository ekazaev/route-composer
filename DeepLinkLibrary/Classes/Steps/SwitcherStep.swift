//
// Created by Eugene Kazaev on 05/02/2018.
//

import Foundation
import UIKit

/// Case Resolver for SwitcherStep
public protocol StepCaseResolver {

    /// Method to be called by SwitcherStep at the moment when it will try to find a previous step for the Router.
    ///
    /// - Parameter context: Context object that been passed to the Router
    /// - Returns: Step to be made by Router, nil if resolver could not decide when step should be previous
    func resolve(with context: Any?) -> RoutingStep?

}

final class SwitcherStep: ChainableStep, PerformableStep {

    private(set) public var previousStep: RoutingStep? = nil

    private var resolvers: [StepCaseResolver]

    func perform(with context: Any?) -> StepResult {
        previousStep = nil
        resolvers.forEach({ resolver in
            guard previousStep == nil, let step = resolver.resolve(with: context) else {
                return
            }
            previousStep = step
        })

        return .continueRouting(nil)
    }

    public init(resolvers: [StepCaseResolver]) {
        self.resolvers = resolvers
    }
}
