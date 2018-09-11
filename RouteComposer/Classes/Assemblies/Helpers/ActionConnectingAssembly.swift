//
// Created by Eugene Kazaev on 31/08/2018.
//

import Foundation

/// Helper class to build a chain of steps. Can not be used directly.
public struct ActionConnectingAssembly<F: Finder, FC: AbstractFactory>: ActionConnecting where F.ViewController == FC.ViewController, F.Context == FC.Context {

    let previousSteps: [RoutingStep]

    let stepToFullFill: StepWithActionAssembly<F, FC>

    init(stepToFullFill: StepWithActionAssembly<F, FC>, previousSteps: [RoutingStep] = []) {
        self.previousSteps = previousSteps
        self.stepToFullFill = stepToFullFill
    }

    /// Connects previously provided `RoutingStep` instance with an `Action`
    ///
    /// - Parameter action: `Action` instance to be used with a step.
    /// - Returns: `ChainAssembly` to continue building the chain.
    public func using<A: Action>(_ action: A) -> StepChainAssembly {
        var previousSteps = self.previousSteps
        previousSteps.append(stepToFullFill.routingStep(with: action))
        return StepChainAssembly(previousSteps: previousSteps)
    }

    /// Connects previously provided `RoutingStep` instance with an `Action`
    ///
    /// - Parameter action: `ContainerAction` instance to be used with a step.
    /// - Returns: `ChainAssembly` to continue building the chain.
    public func using<A: ContainerAction>(_ action: A) -> StepChainAssembly {
        var previousSteps = self.previousSteps
        previousSteps.append(stepToFullFill.embeddableRoutingStep(with: action))
        return StepChainAssembly(previousSteps: previousSteps)
    }

}

public extension ActionConnectingAssembly where FC: NilEntity {

    /// Created to remind user that factory that does not produce anything in most cases should
    /// be used with `NilAction`
    public func usingNoAction() -> StepChainAssembly {
        return using(GeneralAction.NilAction())
    }

}
