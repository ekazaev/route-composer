//
// Created by Eugene Kazaev on 2018-09-17.
//

import Foundation
import UIKit

/// Represents a single step for the `Router` to make.
public struct DestinationStep<VC: UIViewController, C>: RoutingStepWithContext, ChainableStep {

    /// Type of the `ViewController` associated with the step
    public typealias ViewController = VC

    /// Type of the `Context` associated with the step
    public typealias Context = C

    var previousStep: RoutingStep? {
        return destinationStep
    }

    let destinationStep: RoutingStep

    init(_ destinationStep: RoutingStep) {
        self.destinationStep = destinationStep
    }

    /// Removes context type dependency from a step.
    public func unsafelyUnwrapped() -> DestinationStep<UIViewController, Any?> {
        return DestinationStep<UIViewController, Any?>(destinationStep)
    }

}
