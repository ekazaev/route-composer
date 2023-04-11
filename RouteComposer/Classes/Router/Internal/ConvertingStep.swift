//
// RouteComposer
// ConvertingStep.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation

struct ConvertingStep<CT: ContextTransformer>: RoutingStep,
    ChainableStep,
    PerformableStep {

    private let contextTransformer: CT
    private var previousStep: RoutingStep?

    init(contextTransformer: CT, previousStep: RoutingStep?) {
        self.contextTransformer = contextTransformer
        self.previousStep = previousStep
    }

    func getPreviousStep(with context: AnyContext) -> RoutingStep? {
        return previousStep
    }

    func perform(with context: AnyContext) throws -> PerformableStepResult {
        let typedContext: CT.SourceContext = try context.value()
        let newContext = try contextTransformer.transform(typedContext)
        return .updateContext(AnyContextBox(newContext))
    }
}
