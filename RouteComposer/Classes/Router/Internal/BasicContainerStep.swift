//
//  StepResult.swift
//  RouteComposer
//
//  Created by Alexandra Mikhailouskaya on 23/01/2018.
//

import Foundation
import UIKit

/// Base class for steps that produces basic container steps.
public class BasicContainerStep<F: Finder, FC: Container> where F.ViewController == FC.ViewController, F.Context == FC.Context {
    
    internal let routingStep: RoutingStep

    /// Creates a instance of the `RoutingStep` that produces container view controller.
    ///
    /// - Parameters:
    ///   - finder: The `UIViewController` `Finder`.
    ///   - factory: The `UIViewController` `Factory`.
    init(finder: F, factory: FC) {
        routingStep = RoutingContainerStep(finder: finder, factory: factory)
    }
    
    private class RoutingContainerStep: BaseStep<ContainerFactoryBox<FC>>, RoutingStep {
        
        init(finder: F, factory: FC) {
            super.init(finder: finder, factory: factory)
        }
        
    }
    
}
