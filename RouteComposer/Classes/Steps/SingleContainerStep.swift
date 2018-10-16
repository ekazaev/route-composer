//
// Created by Eugene Kazaev on 25/07/2018.
//

import Foundation
import UIKit

/// Base class for the basic container steps.
public class SingleContainerStep<F: Finder, FC: ContainerFactory>: ActionToStepIntegrator<F, FC>
        where
        F.ViewController == FC.ViewController, F.Context == FC.Context {

    let finder: F

    let factory: FC

    /// Creates an instance of the `DestinationStep` describing a container view controller.
    ///
    /// - Parameters:
    ///   - finder: The `UIViewController` `Finder`.
    ///   - factory: The `UIViewController` `ContainerFactory`.
    public init(finder: F, factory: FC) {
        self.finder = finder
        self.factory = factory
    }

    override func routingStep<A: Action>(with action: A) -> RoutingStep {
        return BaseStep<ContainerFactoryBox<FC>>(finder: finder,
                factory:
                factory,
                action: ActionBox(action),
                interceptor: taskCollector.getInterceptorsBoxed(),
                contextTask: taskCollector.getContextTasksBoxed(),
                postTask: taskCollector.getPostTasksBoxed()
        )
    }

    override func embeddableRoutingStep<A: ContainerAction>(with action: A) -> RoutingStep {
        return BaseStep<ContainerFactoryBox<FC>>(finder: finder,
                factory:
                factory,
                action: ContainerActionBox(action),
                interceptor: taskCollector.getInterceptorsBoxed(),
                contextTask: taskCollector.getContextTasksBoxed(),
                postTask: taskCollector.getPostTasksBoxed()
        )
    }

}
