//
// Created by Eugene Kazaev on 25/07/2018.
//

import Foundation
import UIKit

/// Base class for steps that produces basic container steps.
public class BasicContainerStep<F: Finder, FC: Container, C: ContainerViewController>: BasicStepAssembly
        where F.ViewController == FC.ViewController, F.Context == FC.Context, FC.ViewController == C {

    /// Creates a instance of the `RoutingStep` that produces container view controller.
    ///
    /// - Parameters:
    ///   - finder: The `UIViewController` `Finder`.
    ///   - factory: The `UIViewController` `Container`.
    public init(finder: F, factory: FC) {
        super.init(routingStep: BasicStepAssembly.RoutingContainerStep<F, ContainerFactoryBox<FC>>(finder: finder, factory: factory))
    }

}
