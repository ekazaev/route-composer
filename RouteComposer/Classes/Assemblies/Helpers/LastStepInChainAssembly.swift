//
// RouteComposer
// LastStepInChainAssembly.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import UIKit

/// Helper class to build a chain of steps. Can not be used directly.
public struct LastStepInChainAssembly<ViewController: UIViewController, Context> {

    // MARK: Properties

    let previousSteps: [RoutingStep]

    // MARK: Methods

    init(previousSteps: [RoutingStep]) {
        self.previousSteps = previousSteps
    }

    /// Assembles all the provided settings.
    ///
    /// - Returns: The instance of `DestinationStep` with all the settings provided inside.
    public func assemble() -> DestinationStep<ViewController, Context> {
        DestinationStep(chain(previousSteps))
    }

    private func chain(_ steps: [RoutingStep]) -> RoutingStep {
        guard let lastStep = steps.last else {
            preconditionFailure("No steps provided to chain.")
        }

        let firstStep = steps.dropLast().reversed().reduce(lastStep) { result, currentStep in
            guard var step = currentStep as? BaseStep else {
                assertionFailure("\(currentStep) can not be chained to non chainable step \(result)")
                return currentStep
            }
            step.from(result)
            return step
        }

        return firstStep
    }

}
