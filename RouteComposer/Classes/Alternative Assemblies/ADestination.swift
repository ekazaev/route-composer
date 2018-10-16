//
// Created by Eugene Kazaev on 2018-10-16.
//

import Foundation
import UIKit

public struct DestinationAssembly<Context> {

    let previousSteps: [RoutingStep]

    public init<VC: UIViewController>(from startingStep: DestinationStep<VC, Context>) {
        self.previousSteps = [startingStep.destinationStep]
    }

    init(previousSteps: [RoutingStep]) {
        self.previousSteps = previousSteps
    }

    public func using<A: Action>(_ action: A) -> AStepToActionConnectingAssembly<A, Context> {
        print("u1")
        return AStepToActionConnectingAssembly(action: action, previousSteps: previousSteps)
    }

}

public struct ContainerDestinationAssembly<VC: ContainerViewController, Context> {

    let previousSteps: [RoutingStep]

    public init(from startingStep: DestinationStep<VC, Context>) {
        self.previousSteps = [startingStep.destinationStep]
    }

    init(previousSteps: [RoutingStep]) {
        self.previousSteps = previousSteps
    }

    public func inside() -> AStepToActionConnectingAssembly<ViewControllerActions.NilAction, Context>  {
        return AStepToActionConnectingAssembly(action: ViewControllerActions.NilAction(), previousSteps: previousSteps)
    }

    public func using<A: ContainerAction>(_ action: A) -> AStepToContainerActionConnectingAssembly<A, Context> where A.ViewController == VC {
        print("u3")
        return AStepToContainerActionConnectingAssembly(action: action, previousSteps: previousSteps)
    }

}

public class AStepToActionConnectingAssembly<A: Action, C> {

    let action: A

    let previousSteps: [RoutingStep]

    init(action: A, previousSteps: [RoutingStep]) {
        self.action = action
        self.previousSteps = previousSteps
    }

    public func present<F: Finder, FC: AbstractFactory>(_ step: ActionToStepIntegrator<F, FC>) -> AActionConnectingAssembly<F.ViewController, F.Context>
            where F.ViewController == FC.ViewController, F.Context == FC.Context, F.Context == C {
        print("A123")
        var previousSteps = self.previousSteps
        if let routingStep = step.routingStep(with: action) {
            previousSteps.append(routingStep)
        }

        return AActionConnectingAssembly(previousSteps: previousSteps)
    }

    public func present<F: Finder, FC: AbstractFactory>(_ step: ActionToStepIntegrator<F, FC>) -> AContainerActionConnectingAssembly<F.ViewController, F.Context>
            where F.ViewController == FC.ViewController, F.Context == FC.Context, F.ViewController: ContainerViewController, F.Context == C {
        print("A456")
        var previousSteps = self.previousSteps
        if let routingStep = step.routingStep(with: action) {
            previousSteps.append(routingStep)
        }
        return AContainerActionConnectingAssembly<F.ViewController, F.Context>(previousSteps: previousSteps)
    }

}

public class AStepToContainerActionConnectingAssembly<A: ContainerAction, C> {

    let action: A

    let previousSteps: [RoutingStep]

    init(action: A, previousSteps: [RoutingStep]) {
        self.action = action
        self.previousSteps = previousSteps
    }

    public func present<F: Finder, FC: AbstractFactory>(_ step: ActionToStepIntegrator<F, FC>) -> AActionConnectingAssembly<F.ViewController, C>
            where F.ViewController == FC.ViewController, F.Context == FC.Context, F.Context == C {
        print("CA123 \(F.ViewController.self) - \(C.self)")
        var previousSteps = self.previousSteps
        if let routingStep = step.embeddableRoutingStep(with: action) {
            previousSteps.append(routingStep)
        }

        return AActionConnectingAssembly(previousSteps: previousSteps)
    }

    public func present<F: Finder, FC: AbstractFactory>(_ step: ActionToStepIntegrator<F, FC>) -> AContainerActionConnectingAssembly<F.ViewController, C>
            where F.ViewController == FC.ViewController, F.Context == FC.Context, F.ViewController: ContainerViewController, F.Context == C {
        print("CA456")
        var previousSteps = self.previousSteps
        if let routingStep = step.embeddableRoutingStep(with: action) {
            previousSteps.append(routingStep)
        }
        return AContainerActionConnectingAssembly<F.ViewController, F.Context>(previousSteps: previousSteps)
    }

}

public class AActionConnectingAssembly<VC: UIViewController, Context> {

    let previousSteps: [RoutingStep]

    init(previousSteps: [RoutingStep]) {
        self.previousSteps = previousSteps
    }

    public func using<A: Action>(_ action: A) -> AStepToActionConnectingAssembly<A, Context> where A.ViewController == VC {
        print("u2")
        return AStepToActionConnectingAssembly(action: action, previousSteps: previousSteps)
    }

    public func assemble() -> DestinationStep<VC, Context> {
        print("a1")
        return DestinationStep(chain(previousSteps.reversed()))
    }

}

public class AContainerActionConnectingAssembly<AcceptedViewController: ContainerViewController, Context> {

    let previousSteps: [RoutingStep]

    init(previousSteps: [RoutingStep]) {
        self.previousSteps = previousSteps
    }

    public func using<A: ContainerAction>(_ action: A) -> AStepToContainerActionConnectingAssembly<A, Context> where A.ViewController == AcceptedViewController {
        print("u3")
        return AStepToContainerActionConnectingAssembly(action: action, previousSteps: previousSteps)
    }

    public func inside() -> AStepToActionConnectingAssembly<ViewControllerActions.NilAction, Context>  {
        return AStepToActionConnectingAssembly(action: ViewControllerActions.NilAction(), previousSteps: previousSteps)
    }

    public func assemble() -> DestinationStep<AcceptedViewController, Context> {
        print("a2")
        return DestinationStep(chain(previousSteps.reversed()))
    }

}

private func chain(_ steps: [RoutingStep]) -> RoutingStep {
    guard let lastStep = steps.last else {
        fatalError("No steps provided to chain.")
    }

    var restSteps = steps
    var currentStep = lastStep
    restSteps.removeLast()

    for presentingStep in restSteps.reversed() {
        guard var step = presentingStep as? ChainingStep & RoutingStep else {
            assertionFailure("\(presentingStep) can not be chained to non chainable step \(currentStep)")
            return currentStep
        }
        if let chainableStep = presentingStep as? ChainableStep, let previousStep = chainableStep.previousStep {
            assertionFailure("\(presentingStep) is already chained to  \(previousStep)")
            return currentStep
        }
        step.from(currentStep)
        currentStep = step
    }

    return currentStep
}
