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

    /// Removes context and view controller type dependencies from a step.
    public func unsafelyUnwrapping<UVC: UIViewController, UC>() -> DestinationStep<UVC, UC> {
        return DestinationStep<UVC, UC>(destinationStep)
    }

    /// Allows to avoid container view controller check.
    ///
    /// *NB:* Developer guaranties that it will be there in runtime.
    public func expectingContainer<VC: ContainerViewController>() -> DestinationStep<VC, Context> {
        return DestinationStep<VC, Context>(destinationStep)
    }

}

/// A step that has a context equal to Optional(Any) can be build with any type of context passed to the router.
extension DestinationStep where DestinationStep.Context == Any? {

    /// Allows to avoid container view controller check. This method is available only for the steps that are
    /// able to accept any type of context.
    ///
    /// *NB:* Developer guaranties that it will be there.
    public func expectingContainer<VC: ContainerViewController, C>() -> DestinationStep<VC, C> {
        return DestinationStep<VC, C>(destinationStep)
    }

    /// Allows to avoid context type check. A step that has context equal to Optional(Any) can be build with any type of context passed to the router.
    ///
    /// *NB:* Developer guaranties that it will be there.
    public func adoptingContext<C>() -> DestinationStep<ViewController, C> {
        return DestinationStep<ViewController, C>(destinationStep)
    }

}
