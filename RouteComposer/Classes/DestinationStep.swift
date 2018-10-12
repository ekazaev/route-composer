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
    public func unsafelyUnwrapped<UVC: UIViewController, UC>() -> DestinationStep<UVC, UC> {
        return DestinationStep<UVC, UC>(destinationStep)
    }

    /// Allows to avoid container view controller checks.
    ///
    /// *NB:* Developer guaranties that it will be there in runtime.
    public func asContainer<VC: ContainerViewController>() -> DestinationStep<VC, Context> {
        return DestinationStep<VC, Context>(destinationStep)
    }

}
