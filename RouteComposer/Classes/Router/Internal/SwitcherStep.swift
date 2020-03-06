//
// RouteComposer
// SwitcherStep.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2020.
// Distributed under the MIT license.
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
        return resolvers.reduce(nil as RoutingStep?) { result, resolver in
            guard result == nil else {
                return result
            }
            return resolver.resolve(with: context)
        }
    }

    init(resolvers: [StepCaseResolver]) {
        self.resolvers = resolvers
    }

}

#endif
