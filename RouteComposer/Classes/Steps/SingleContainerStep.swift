//
// Created by Eugene Kazaev on 25/07/2018.
//

import Foundation
import UIKit

/// Base class for the basic container steps.
public class SingleContainerStep<F: Finder, FC: Container, C: ContainerViewController>: StepWithActionAssembly<F, FC>
        where
        F.ViewController == FC.ViewController, F.Context == FC.Context, FC.ViewController == C {

    let finder: F

    let factory: FC

    /// Creates a instance of the `RoutingStep` describing a container view controller.
    ///
    /// - Parameters:
    ///   - finder: The `UIViewController` `Finder`.
    ///   - factory: The `UIViewController` `Container`.
    public init(finder: F, factory: FC) {
        self.finder = finder
        self.factory = factory
    }

    override func routingStep(with action: Action) -> RoutingStep {
        return FinalRoutingStep<ContainerFactoryBox<FC>>(finder: finder,
                factory:
                factory,
                action: action,
                interceptor: taskCollector.interceptor(),
                contextTask: taskCollector.contextTask(),
                postTask: taskCollector.postTask(),
                previousStep: nil
        )
    }

}
