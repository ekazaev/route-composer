//
// Created by Eugene Kazaev on 05/02/2018.
//

import Foundation
import UIKit

protocol StepCaseResolver {

    func resolve(with context: Any?) -> RoutingStep?

}

class SwitcherStep: RoutingStep, ChainableStep {

    var resolvers: [StepCaseResolver]

    func getPreviousStep(with context: Any?) -> RoutingStep? {
        return resolvers.reduce(nil as RoutingStep?, { (result, resolver) in
            guard result == nil else {
                return result
            }
            return resolver.resolve(with: context)
        })
    }

    init(resolvers: [StepCaseResolver]) {
        self.resolvers = resolvers
    }

}
