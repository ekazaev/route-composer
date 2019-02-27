//
// Created by Eugene Kazaev on 31/08/2018.
//

import Foundation
import UIKit

/// Helper class to build a chain of steps. Can not be used directly.
public struct ActionConnectingAssembly<PVC: UIViewController, VC: UIViewController, C>: ActionConnecting {

    let previousSteps: [RoutingStep]

    let stepToFullFill: ActionToStepIntegrator<PVC, C>

    init(stepToFullFill: ActionToStepIntegrator<PVC, C>, previousSteps: [RoutingStep] = []) {
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
