//
// Created by Eugene Kazaev on 23/01/2018.
//

import Foundation
import UIKit

/// Base router step implementation that handles all step protocols.
public class RouterStep: ChainableStep, PerformableStep, ChainingStep {

    private(set) public var previousStep: RoutingStep? = nil

    let factory: AnyFactory

    public init<F: Factory>(factory: F) {
        self.factory = FactoryBox(factory)
    }

    public init<F: Factory & Container>(factory: F) {
        self.factory = ContainerFactoryBox(factory)
    }

    public init<F: AnyFactory>(factory: F) {
        self.factory = factory
    }

    public func viewController(with context: Any?) -> UIViewController? {
        return nil
    }

    func perform(with context: Any?) -> StepResult {
        return .continueRouting(factory)
    }

    public func from(_ step: RoutingStep) {
        previousStep = step
    }

}
