//
// Created by Eugene Kazaev on 23/01/2018.
//

import Foundation
import UIKit

/// Base router `RoutingStep` implementation that handles all step protocols.
class BaseStep<Box: AnyFactoryBox>: RoutingStep, InterceptableStep, ChainableStep, PerformableStep, ChainingStep, CustomStringConvertible {

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
        } else if let finder = finder, finder as? NilEntity == nil {
            self.factory = FactoryBox.box(for: FinderFactory(finder: finder), action: ActionBox(GeneralAction.NilAction()))
        } else {
            self.factory = nil
        }
        self.interceptor = interceptor
        self.contextTask = contextTask
        self.postTask = postTask
    }

    func perform<D: RoutingDestination>(for destination: D) -> StepResult {
        guard let viewController = finder?.findViewController(with: destination.context) else {
            return .continueRouting(factory)
        }
        return .success(viewController)
    }

    public func from(_ step: RoutingStep) {
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
        return "\(String(describing: type(of: self)))<\(finderDescription) : \(factoryDescription))>"
    }

}
