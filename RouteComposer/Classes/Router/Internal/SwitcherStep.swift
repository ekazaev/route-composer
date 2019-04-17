//
// Created by Eugene Kazaev on 05/02/2018.
//

import Foundation
import UIKit

protocol StepCaseResolver {

    func resolve<Context>(with context: Context) -> RoutingStep?

}

class SwitcherStep: RoutingStep, ChainableStep {

    var resolvers: [StepCaseResolver]

    func getPreviousStep<Context>(with context: Context) -> RoutingStep? {
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
