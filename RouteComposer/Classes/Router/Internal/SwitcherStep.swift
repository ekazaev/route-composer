//
// Created by Eugene Kazaev on 05/02/2018.
//

#if os(iOS)

import Foundation
import UIKit

protocol StepCaseResolver {

    func resolve<Context>(with context: Context) -> RoutingStep?

}

final class SwitcherStep: RoutingStep, ChainableStep {

    final var resolvers: [StepCaseResolver]

    final func getPreviousStep<Context>(with context: Context) -> RoutingStep? {
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

#endif
