//
// Created by Eugene Kazaev on 25/07/2018.
//

import Foundation
import UIKit

/// A simple class that produces an intermediate `ActionToStepIntegrator` describing a container view controller.
public class SingleContainerStep<F: Finder, FC: ContainerFactory>: ActionToStepIntegrator<F, FC>
        where
        F.ViewController == FC.ViewController, F.Context == FC.Context {

    let finder: F

    let factory: FC

    /// Creates an instance of the `ActionToStepIntegrator` describing a container view controller.
    ///
    /// - Parameters:
    ///   - finder: The `UIViewController` `Finder`.
    ///   - factory: The `UIViewController` `ContainerFactory`.
    public init(finder: F, factory: FC) {
        self.finder = finder
        self.factory = factory
    }

    override func routingStep<A: Action>(with action: A) -> RoutingStep {
        let entitiesCollector = BaseEntitiesCollector<ContainerFactoryBox<FC>, ActionBox>(finder: finder, factory: factory, action: action)
        return BaseStep(entitiesProvider: entitiesCollector, taskProvider: taskCollector)
    }

    override func embeddableRoutingStep<A: ContainerAction>(with action: A) -> RoutingStep {
        let entitiesCollector = BaseEntitiesCollector<ContainerFactoryBox<FC>, ContainerActionBox>(finder: finder, factory: factory, action: action)
        return BaseStep(entitiesProvider: entitiesCollector, taskProvider: taskCollector)
    }

}
