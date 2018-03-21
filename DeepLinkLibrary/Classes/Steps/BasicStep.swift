//
// Created by Eugene Kazaev on 23/01/2018.
//

import Foundation
import UIKit

/// Simple class that produces intermediate step for an assembly.
public class BasicStep<F: Finder, FC: Factory> where F.ViewController == FC.ViewController, F.Context == FC.Context {

    let routingStep: RoutingStep

    /// Creates a instance of the routing step that produces view controller.
    ///
    /// - Parameters:
    ///   - finder: UIViewController finder.
    ///   - factory: UIViewController factory.
    public init(finder: F, factory: FC)  {
        routingStep = RoutingContainerStep(finder: finder, factory: factory)
    }

    private class RoutingContainerStep: BaseStep, RoutingStep {

        init<F: Finder, FC: Factory>(finder: F, factory: FC) where F.ViewController == FC.ViewController, F.Context == FC.Context {
            super.init(finder: finder, factory: factory)
        }

    }

}
