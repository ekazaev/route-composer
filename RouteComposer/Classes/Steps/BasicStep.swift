//
// Created by Eugene Kazaev on 25/07/2018.
//

import Foundation
import UIKit

/// A simple class that produces intermediate `RoutingStep` for an assembly.
public final class BasicStep<F: Finder, FC: Factory>: BasicStepAssembly where F.ViewController == FC.ViewController, F.Context == FC.Context {

    /// Creates a instance of the `RoutingStep` that produces container view controller.
    ///
    /// - Parameters:
    ///   - finder: The `UIViewController` `Finder`.
    ///   - factory: The `UIViewController` `Factory`.
    public init(finder: F, factory: FC) {
        super.init(routingStep: RoutingContainerStep<F, FactoryBox<FC>>(finder: finder, factory: factory))
    }

}
