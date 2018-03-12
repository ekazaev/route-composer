//
// Created by Eugene Kazaev on 23/01/2018.
//

import Foundation
import UIKit

/// Simple class that produces intermediate step for an assembly.
public class BasicStep {

    let routingStep: RoutingContainerStep

    /// Creates a instance of the routing step that produces view controller.
    ///
    /// - Parameters:
    ///   - finder: UIViewController finder.
    ///   - factory: UIViewController factory.
    public init<F: Finder, FC: Factory>(finder: F, factory: FC) where F.ViewController == FC.ViewController, F.Context == FC.Context {
        routingStep = RoutingContainerStep(finder: finder, factory: factory)
    }

    class RoutingContainerStep: BaseStep, RoutingStep {

        init<F: Finder, FC: Factory>(finder: F, factory: FC) where F.ViewController == FC.ViewController, F.Context == FC.Context {
            super.init(finder: finder, factory: factory)
        }

    }

}
