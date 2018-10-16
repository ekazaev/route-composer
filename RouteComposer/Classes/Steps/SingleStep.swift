//
// Created by Eugene Kazaev on 25/07/2018.
//

import Foundation
import UIKit

/// A simple class that produces an intermediate `ActionToStepIntegrator`.
public final class SingleStep<F: Finder, FC: Factory>: ActionToStepIntegrator<F, FC>
        where F.ViewController == FC.ViewController, F.Context == FC.Context {

    let finder: F

    let factory: FC

    /// A simple class that produces an intermediate `ActionToStepIntegrator`.
    ///
    /// - Parameters:
    ///   - finder: The `UIViewController` `Finder`.
    ///   - factory: The `UIViewController` `Factory`.
    public init(finder: F, factory: FC) {
        self.finder = finder
        self.factory = factory
    }

    override func routingStep<A: Action>(with action: A) -> RoutingStep {
        return BaseStep<FactoryBox<FC>>(finder: finder,
                factory: factory,
                action: ActionBox(action),
                interceptor: taskCollector.getInterceptorsBoxed(),
                contextTask: taskCollector.getContextTasksBoxed(),
                postTask: taskCollector.getPostTasksBoxed()
        )
    }

    override func embeddableRoutingStep<A: ContainerAction>(with action: A) -> RoutingStep {
        return BaseStep<FactoryBox<FC>>(finder: finder,
                factory: factory,
                action: ContainerActionBox(action),
                interceptor: taskCollector.getInterceptorsBoxed(),
                contextTask: taskCollector.getContextTasksBoxed(),
                postTask: taskCollector.getPostTasksBoxed()
        )
    }

}
