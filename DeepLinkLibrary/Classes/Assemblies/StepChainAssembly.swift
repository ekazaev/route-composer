//
// Created by Eugene Kazaev on 07/02/2018.
//

import Foundation

/// Connects array of steps into a chain of steps.
/// ### Usage
/// ```swift
/// let intermediateStep = StepChainAssembly()
///         .from(NavigationControllerStep(action: PresentModallyAction()))
///         .from(CurrentViewControllerStep())
///         .assemble()
/// ```
public class StepChainAssembly {

    /// Nested builder that does not allow to add steps from non-chainable step
    public class LastStepInChainAssembly {

        fileprivate var assembly: StepChainAssembly

        // Internal init protects from instantiating builder outside of the library
        init(assembly: StepChainAssembly) {
            self.assembly = assembly
        }

        /// Assemble all the provided settings.
        ///
        /// - Returns: Instance of RoutingStep with all the settings provided inside.
        public func assemble() -> RoutingStep {
            return assembly.assemble()
        }

    }

    var previousSteps: [RoutingStep] = []

    public init() {
    }

    /// Previous step to start build current step from
    ///
    /// - Parameter previousStep: Instance of RoutingStep
    public func from(_ previousStep: RoutingStep) -> LastStepInChainAssembly {
        self.previousSteps.append(previousStep)
        return LastStepInChainAssembly(assembly: self)
    }

    /// Previous step to start build current step from
    ///
    /// - Parameter previousStep: Instance of RoutingStep
    public func from(_ previousStep: RoutingStep & ChainingStep) -> Self {
        self.previousSteps.append(previousStep)
        return self
    }

    /// Basic step to start build current step from
    ///
    /// - Parameter previousStep: Instance of ChainingStep
    public func from<F, FC>(_ previousStep: BasicStep<F, FC>) -> Self {
        self.previousSteps.append(previousStep.routingStep)
        return self
    }

    /// Assemble all the provided settings.
    ///
    /// - Returns: Instance of RoutingStep with all the settings provided inside.
    public func assemble() -> RoutingStep {
        return chain(previousSteps)
    }
}

func chain(_ steps: [RoutingStep]) -> RoutingStep {
    guard let firstStep = steps.first else {
        fatalError("No steps provided to chain.")
    }

    var restSteps = steps
    var currentStep = firstStep
    restSteps.removeFirst()

    for presentingStep in restSteps {
        guard let step = currentStep as? ChainingStep else {
            fatalError("\(presentingStep) can not be chained to non chainable step \(currentStep)")
        }
        if let chainableStep = step as? ChainableStep, let previousStep = chainableStep.previousStep {
            fatalError("\(currentStep) is already chained to  \(previousStep)")
        }
        step.from(presentingStep)
        currentStep = presentingStep
    }

    return firstStep
}
