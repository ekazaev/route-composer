//
// Created by Eugene Kazaev on 31/08/2018.
//

import Foundation
import UIKit

/// Helper class to build a chain of steps. Can not be used directly.
public struct ActionConnectingAssembly<F: Finder, FC: AbstractFactory, VC: UIViewController, C>: ActionConnecting
        where F.ViewController == FC.ViewController, F.Context == FC.Context {

    let previousSteps: [RoutingStep]

    let stepToFullFill: ActionToStepIntegrator<F, FC>

    init(stepToFullFill: ActionToStepIntegrator<F, FC>, previousSteps: [RoutingStep] = []) {
        self.previousSteps = previousSteps
        self.stepToFullFill = stepToFullFill
    }

    public func using<A: Action>(_ action: A) -> StepChainAssembly<VC, C> {
        var previousSteps = self.previousSteps
        if let routingStep = stepToFullFill.routingStep(with: action) {
            previousSteps.append(routingStep)
        }
        return StepChainAssembly(previousSteps: previousSteps)
    }

    public func using<A: ContainerAction>(_ action: A) -> ContainerStepChainAssembly<A.ViewController, VC, C> {
        var previousSteps = self.previousSteps
        if let routingStep = stepToFullFill.embeddableRoutingStep(with: action) {
            previousSteps.append(routingStep)
        }
        return ContainerStepChainAssembly(previousSteps: previousSteps)
    }

}
