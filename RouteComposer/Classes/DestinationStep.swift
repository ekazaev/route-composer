//
// RouteComposer
// DestinationStep.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
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

    func getPreviousStep<Context>(with context: Context) -> RoutingStep? {
        destinationStep
    }

    /// Adapts context and view controller type dependencies.
    ///
    /// *NB:* Developer guaranties that this types will compliment in runtime.
    public func unsafelyRewrapped<VC: UIViewController, C>() -> DestinationStep<VC, C> {
        DestinationStep<VC, C>(destinationStep)
    }

    struct ConvertingStep<SourceContext, TargetContext>: RoutingStep,
            ChainableStep,
            PerformableStep {

        private let block: (SourceContext) -> TargetContext
        private var previousStep: RoutingStep?

        init(block: @escaping (SourceContext) -> TargetContext, previousStep: RoutingStep?) {
            self.block = block
            self.previousStep = previousStep
        }

        func getPreviousStep(with context: Any?) -> RoutingStep? {
            return previousStep
        }

        func perform(with context: Any?) throws -> PerformableStepResult {
            guard let typedContext = Any?.some(context as Any) as? SourceContext else {
                throw RoutingError.typeMismatch(type: type(of: context),
                        expectedType: SourceContext.self,
                        .init("\(String(describing: C.self)) can not be converted to \(String(describing: SourceContext.self))."))
            }
            let newContext = block(typedContext)
            return .updateContext(newContext)
        }
    }

    /// Adapts context and view controller type dependencies.
    ///
    /// *NB:* Developer guaranties that this types will compliment in runtime.
    public func adaptingContext<VC: UIViewController, C>(block: @escaping (C) -> Context) -> DestinationStep<VC, C> {
        DestinationStep<VC, C>(ConvertingStep(block: block, previousStep: destinationStep))
    }

    /// Allows to avoid container view controller check.
    ///
    /// *NB:* Developer guaranties that it will be there in the runtime.
    public func expectingContainer<VC: ContainerViewController>() -> DestinationStep<VC, Context> {
        DestinationStep<VC, Context>(destinationStep)
    }

}

// MARK: Helper methods where the Context is Any?

/// A step that has a context type Optional(Any) can be build with any type of context passed to the router.
public extension DestinationStep where DestinationStep.Context == Any? {

    /// Allows to avoid container view controller check. This method is available only for the steps that are
    /// able to accept any type of context.
    ///
    /// *NB:* Developer guaranties that it will be there in the runtime.
    func expectingContainer<VC: ContainerViewController, C>() -> DestinationStep<VC, C> {
        DestinationStep<VC, C>(destinationStep)
    }

    /// Allows to compliment to the type check. A step that has context equal to Optional(Any) can be build
    /// with any type of context passed to the router.
    func adaptingContext<C>() -> DestinationStep<ViewController, C> {
        DestinationStep<ViewController, C>(destinationStep)
    }

}
