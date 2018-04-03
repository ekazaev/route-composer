//
// Created by Eugene Kazaev on 23/01/2018.
//

import Foundation
import UIKit

/// A simple class that produces intermediate `RoutingStep` for an assembly.
public class BasicStep<F: Finder, FC: Factory> where F.ViewController == FC.ViewController, F.Context == FC.Context {

    let routingStep: RoutingStep

    /// Creates a instance of the `RoutingStep` that produces view controller.
    ///
    /// - Parameters:
    ///   - finder: The `UIViewController` `Finder` instance.
    ///   - factory: The `UIViewController` `Factory` instance.
    public init(finder: F, factory: FC)  {
        routingStep = RoutingContainerStep(finder: finder, factory: factory)
    }

    private class RoutingContainerStep: BaseStep, RoutingStep {

        init<F: Finder, FC: Factory>(finder: F, factory: FC) where F.ViewController == FC.ViewController, F.Context == FC.Context {
            super.init(finder: finder, factory: factory)
        }

    }

}
