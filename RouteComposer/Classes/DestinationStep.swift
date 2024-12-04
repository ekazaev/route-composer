//
// RouteComposer
// DestinationStep.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import UIKit

/// Represents a single step for the `Router` to make.
public struct DestinationStep<VC: UIViewController, C>: RoutingStep, ChainableStep {

    // MARK: Associated types

    /// Type of the `ViewController` associated with the step
    public typealias ViewController = VC

    /// Type of the `Context` associated with the step
    public typealias Context = C

    // MARK: Properties

    let destinationStep: RoutingStep

    // MARK: Methods

    init(_ destinationStep: RoutingStep) {
        self.destinationStep = destinationStep
    }

    func getPreviousStep(with context: AnyContext) -> RoutingStep? {
        destinationStep
    }

    /// Adapts context and view controller type dependencies.
    ///
    /// *NB:* Developer guaranties that this types will compliment in runtime.
    @MainActor public func unsafelyRewrapped<NewVC: UIViewController, NewC>() -> DestinationStep<NewVC, NewC> {
        DestinationStep<NewVC, NewC>(destinationStep)
    }

    /// Transforms context using `ContextTransformer` provided.
    @MainActor public func adaptingContext<T: ContextTransformer>(using contextTransformer: T) -> DestinationStep<VC, T.SourceContext> where T.TargetContext == C {
        DestinationStep<VC, T.SourceContext>(ConvertingStep(contextTransformer: contextTransformer, previousStep: destinationStep))
    }

    /// Allows to avoid container view controller check.
    ///
    /// *NB:* Developer guaranties that it will be there in the runtime.
    @MainActor public func expectingContainer<NewVC: ContainerViewController>() -> DestinationStep<NewVC, Context> {
        DestinationStep<NewVC, Context>(destinationStep)
    }

}

// MARK: Helper methods where the Context is Any?

/// A step that has a context type Optional(Any) can be build with any type of context passed to the router.
public extension DestinationStep where DestinationStep.Context == Any? {

    /// Allows to avoid container view controller check. This method is available only for the steps that are
    /// able to accept any type of context.
    ///
    /// *NB:* Developer guaranties that it will be there in the runtime.
    @MainActor func expectingContainer<NewVC: ContainerViewController, NewC>() -> DestinationStep<NewVC, NewC> {
        DestinationStep<NewVC, NewC>(destinationStep)
    }

    /// Allows to compliment to the type check. A step that has context equal to Optional(Any) can be build
    /// with any type of context passed to the router.
    @MainActor func adaptingContext<NewC>() -> DestinationStep<ViewController, NewC> {
        DestinationStep<ViewController, NewC>(destinationStep)
    }

}
