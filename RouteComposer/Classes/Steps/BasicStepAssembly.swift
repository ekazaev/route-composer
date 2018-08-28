//
// Created by Eugene Kazaev on 23/01/2018.
//

import Foundation
import UIKit

/// A simple class that produces intermediate `RoutingStep` for an assembly.
public class BasicStepAssembly {
    
    internal let routingStep: RoutingStep
    
    init(routingStep: RoutingStep) {
        self.routingStep = routingStep
    }
    
    final class RoutingContainerStep<F: Finder, Box: AnyFactoryBox>: BaseStep<Box>, RoutingStep where F.ViewController == Box.FactoryType.ViewController, F.Context == Box.FactoryType.Context {
        
        init(finder: F, factory: Box.FactoryType) {
            super.init(finder: finder, factory: factory)
        }
        
    }
    
}
