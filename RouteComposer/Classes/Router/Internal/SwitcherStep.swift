//
// RouteComposer
// SwitcherStep.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2025.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import UIKit

@MainActor
protocol StepCaseResolver {

    func resolve(with context: AnyContext) -> RoutingStep?

}

@MainActor
final class SwitcherStep: RoutingStep, ChainableStep {

    final var resolvers: [StepCaseResolver]

    final func getPreviousStep(with context: AnyContext) -> RoutingStep? {
        resolvers.reduce(nil as RoutingStep?) { result, resolver in
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
