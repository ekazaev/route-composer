//
// Created by Eugene Kazaev on 23/01/2018.
//

import Foundation
import UIKit

// Handles all step protocols.
struct BaseStep<Box: AnyFactoryBox>: RoutingStepWithContext,
        ChainableStep,
        ChainingStep,
        InterceptableStep,
        PerformableStep,
        CustomStringConvertible {

    typealias Context = Box.FactoryType.Context

    private(set) public var previousStep: RoutingStep?

    let factory: AnyFactory?

    let finder: AnyFinder?

    let interceptor: AnyRoutingInterceptor?

    let postTask: AnyPostRoutingTask?

    let contextTask: AnyContextTask?

    init<F: Finder>(finder: F?,
                    factory: Box.FactoryType?,
                    action: AnyAction,
                    interceptor: AnyRoutingInterceptor?,
                    contextTask: AnyContextTask?,
                    postTask: AnyPostRoutingTask?,
                    previousStep: RoutingStep? = nil)
            where F.ViewController == Box.FactoryType.ViewController, F.Context == Box.FactoryType.Context {
        self.previousStep = previousStep
        self.finder = FinderBox.box(for: finder)
        if let anyFactory = Box.box(for: factory, action: action) {
            self.factory = anyFactory
        } else if let finder = finder, !(finder is NilEntity) {
            self.factory = FactoryBox.box(for: FinderFactory(finder: finder),
                    action: ActionBox(UIViewController.NilAction()))
        } else {
            self.factory = nil
        }
        self.interceptor = interceptor
        self.contextTask = contextTask
        self.postTask = postTask
        }

    func perform(with context: Any?) -> StepResult {
        guard let viewController = finder?.findViewController(with: context) else {
            return .continueRouting(factory)
        }
        return .success(viewController)
    }

    mutating func from(_ step: RoutingStep) {
        previousStep = step
    }

    public var description: String {
        var finderDescription = "None"
        var factoryDescription = "None"
        if let finder = finder {
            finderDescription = String(describing: finder)
        }
        if let factory = factory {
            factoryDescription = String(describing: factory)
        }
        return "BaseStep<\(finderDescription) : \(factoryDescription))>"
    }

}
