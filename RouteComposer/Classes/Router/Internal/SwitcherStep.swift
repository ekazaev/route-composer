//
// Created by Eugene Kazaev on 05/02/2018.
//

import Foundation
import UIKit

protocol StepCaseResolver {

    func resolve(for destination: Any?) -> RoutingStep?

}

class SwitcherStep<C>: RoutingStepWithContext, ChainableStep, PerformableStep {

    public typealias Context = C

    private(set) var previousStep: RoutingStep?

    var resolvers: [StepCaseResolver]

    func perform(for destination: Any?) -> StepResult {
        previousStep = nil
        resolvers.forEach({ resolver in
            guard previousStep == nil, let step = resolver.resolve(for: destination) else {
                return
            }
            previousStep = step
        })

        guard previousStep != nil else {
            return .failure
        }
        return .continueRouting(nil)
    }

    init(resolvers: [StepCaseResolver]) {
        self.resolvers = resolvers
    }

}
