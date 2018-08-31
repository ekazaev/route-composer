//
// Created by Eugene Kazaev on 31/08/2018.
//

import Foundation

/// Helper class to build a chain of steps. Can not be used directly.
public struct TypedScreenStepChainAssembly<F: Finder, FC: AbstractFactory>: Usable where F.ViewController == FC.ViewController, F.Context == FC.Context {

    let previousSteps: [RoutingStep]

    let stepToFullFill: StepWithActionAssembly<F, FC>

    init(stepToFullFill: StepWithActionAssembly<F, FC>, previousSteps: [RoutingStep]) {
        self.previousSteps = previousSteps
        self.stepToFullFill = stepToFullFill
    }

    public func using(_ action: Action) -> ChainAssembly {
        var previousSteps = self.previousSteps
        previousSteps.append(stepToFullFill.routingStep(with: action))
        return ChainAssembly(previousSteps: previousSteps)
    }
}

public extension TypedScreenStepChainAssembly where FC: NilEntity {

    /// Created to remind user that factory that does not produce anything in most cases should
    /// be used with `NilAction`
    public func usingNoAction() -> ChainAssembly {
        return using(GeneralAction.NilAction())
    }

}
