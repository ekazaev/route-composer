//
// Created by Eugene Kazaev on 05/02/2018.
//

import Foundation
import UIKit

public protocol StepCaseResolver {

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
