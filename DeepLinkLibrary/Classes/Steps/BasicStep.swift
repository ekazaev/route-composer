//
// Created by Eugene Kazaev on 23/01/2018.
//

import Foundation
import UIKit

/// Base router step implementation that handles all step protocols.
public class BasicStep: ChainableStep, PerformableStep, ChainingStep, CustomStringConvertible {

    internal(set) public var previousStep: RoutingStep? = nil

    let factory: AnyFactory?

    let finder: AnyFinder?

    /// Creates a basic instance of the routing step.
    ///
    /// - Parameters:
    ///   - finder: UIViewController finder.
    ///   - factory: UIViewController factory.
    init<F: Finder, FC: Factory>(finder: F, factory: FC) where F.ViewController == FC.ViewController, F.Context == FC.Context  {
        self.factory = FactoryBox.box(for: factory)
        self.finder = FinderBox.box(for: finder)
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
