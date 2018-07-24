//
// Created by Eugene Kazaev on 23/01/2018.
//

import Foundation
import UIKit

/// A simple class that produces intermediate `RoutingStep` for an assembly.
public class BasicStep {
    
    internal let routingStep: RoutingStep
    
    /// Creates a instance of the `RoutingStep` that produces view controller.
    ///
    /// - Parameters:
    ///   - finder: The `UIViewController` `Finder` instance.
    ///   - factory: The `UIViewController` `Factory` instance.
    public init<F: Finder, FC: Factory>(finder: F, factory: FC) where F.ViewController == FC.ViewController, F.Context == FC.Context {
        routingStep = RoutingContainerStep<F, FactoryBox<FC>>(finder: finder, factory: factory)
    }
    
    /// Creates a instance of the `RoutingStep` that produces view controller.
    ///
    /// - Parameters:
    ///   - finder: The `UIViewController` `Finder` instance.
    ///   - container: The `UIViewController` `Container` instance.
    public init<F: Finder, FC: Container>(finder: F, container: FC) where F.ViewController == FC.ViewController, F.Context == FC.Context {
        routingStep = RoutingContainerStep<F, ContainerFactoryBox<FC>>(finder: finder, factory: container)
    }
    
    private class RoutingContainerStep<F: Finder, Box: AnyFactoryBox>: BaseStep<Box>, RoutingStep where F.ViewController == Box.FactoryType.ViewController, F.Context == Box.FactoryType.Context {
        
        init(finder: F, factory: Box.FactoryType) {
            super.init(finder: finder, factory: factory)
        }
        
    }
    
}
