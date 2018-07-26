//
// Created by Eugene Kazaev on 23/01/2018.
//

import Foundation
import UIKit

/// Base router `RoutingStep` implementation that handles all step protocols.
class BaseStep<Box: AnyFactoryBox>: ChainableStep, PerformableStep, ChainingStep, CustomStringConvertible {

    private(set) public var previousStep: RoutingStep? = nil

    let factory: AnyFactory?

    let finder: AnyFinder?

    /// Creates a basic instance of the routing step.
    ///
    /// - Parameters:
    ///   - finder: The  `UIViewController` `Finder`.
    ///   - factory: The `UIViewController` `Factory`.
    init<F: Finder>(finder: F?, factory: Box.FactoryType?, previousStep: RoutingStep? = nil) where F.ViewController == Box.FactoryType.ViewController, F.Context == Box.FactoryType.Context  {
        self.previousStep = previousStep
        self.finder = FinderBox.box(for: finder)
        if let anyFactory = Box.box(for: factory) {
            self.factory = anyFactory
        } else if let finder = finder, finder as? NilEntity == nil {
            self.factory = FactoryBox.box(for: FinderFactory(finder: finder))
        } else {
            self.factory = nil
        }
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
