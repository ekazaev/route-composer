//
// Created by Eugene Kazaev on 05/02/2018.
//

import Foundation
import UIKit

public protocol SmartStepResolver {

    func resolve(with arguments: Any?) -> RoutingStep?

}

class SmartStep: ChainableStep, PerformableStep {

    private(set) public var previousStep: RoutingStep? = nil

    private var resolvers: [SmartStepResolver]

    func perform(with arguments: Any?) -> StepResult {
        previousStep = nil
        resolvers.forEach({ resolver in
            guard previousStep == nil, let step = resolver.resolve(with: arguments) else {
                return
            }
            previousStep = step
        })

        return .continueRouting(nil)
    }

    public init(resolvers: [SmartStepResolver]) {
        self.resolvers = resolvers
    }
}
