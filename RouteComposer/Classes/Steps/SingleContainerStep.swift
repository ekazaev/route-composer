//
// RouteComposer
// SingleContainerStep.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2020.
// Distributed under the MIT license.
//

#if os(iOS)

import Foundation
import UIKit

/// A simple class that produces an intermediate `ActionToStepIntegrator` describing a container view controller.
public class SingleContainerStep<F: Finder, FC: ContainerFactory>: ActionToStepIntegrator<F.ViewController, F.Context>
    where
    F.ViewController == FC.ViewController, F.Context == FC.Context {

    // MARK: Internal entities

    final class UnsafeWrapper<VC: UIViewController, C, F: Finder, FC: ContainerFactory>: ActionToStepIntegrator<VC, C>
        where
        F.ViewController == FC.ViewController, F.Context == FC.Context {

        final let step: SingleContainerStep<F, FC>

        init(step: SingleContainerStep<F, FC>) {
            self.step = step
            super.init(taskCollector: step.taskCollector)
        }

        final override func routingStep<A: Action>(with action: A) -> RoutingStep? {
            return step.routingStep(with: action)
        }

        final override func embeddableRoutingStep<A: ContainerAction>(with action: A) -> RoutingStep? {
            return step.embeddableRoutingStep(with: action)
        }

    }

    // MARK: Properties

    final let finder: F

    final let factory: FC

    // MARK: Methods

    /// Creates an instance of the `ActionToStepIntegrator` describing a container view controller.
    ///
    /// - Parameters:
    ///   - finder: The `UIViewController` `Finder`.
    ///   - factory: The `UIViewController` `ContainerFactory`.
    public init(finder: F, factory: FC) {
        self.finder = finder
        self.factory = factory
    }

    final override func routingStep<A: Action>(with action: A) -> RoutingStep {
        let entitiesCollector = BaseEntitiesCollector<ContainerFactoryBox<FC>, ActionBox>(finder: finder, factory: factory, action: action)
        return BaseStep(entitiesProvider: entitiesCollector, taskProvider: taskCollector)
    }

    final override func embeddableRoutingStep<A: ContainerAction>(with action: A) -> RoutingStep {
        let entitiesCollector = BaseEntitiesCollector<ContainerFactoryBox<FC>, ContainerActionBox>(finder: finder, factory: factory, action: action)
        return BaseStep(entitiesProvider: entitiesCollector, taskProvider: taskCollector)
    }

    /// Adapts context and view controller type dependencies.
    ///
    /// *NB:* Developer guaranties that this types will compliment in runtime.
    public final func unsafelyRewrapped<VC: UIViewController, C>() -> ActionToStepIntegrator<VC, C> {
        return UnsafeWrapper(step: self)
    }

    /// Allows to avoid container view controller check.
    ///
    /// *NB:* Developer guaranties that it will be there in the runtime.
    public final func expectingContainer<VC: ContainerViewController>() -> ActionToStepIntegrator<VC, F.Context> {
        return UnsafeWrapper(step: self)
    }

}

// MARK: Helper methods where the Context is Any?

extension SingleContainerStep where FC.Context == Any? {

    /// Allows to avoid container view controller check. This method is available only for the steps that are
    /// able to accept any type of context.
    ///
    /// *NB:* Developer guaranties that it will be there in the runtime.
    public final func expectingContainer<VC: ContainerViewController, C>() -> ActionToStepIntegrator<VC, C> {
        return UnsafeWrapper(step: self)
    }

    /// Allows to compliment to the type check. A step that has context equal to Optional(Any) can be build
    /// with any type of context passed to the router.
    public final func adaptingContext<C>() -> ActionToStepIntegrator<F.ViewController, C> {
        return UnsafeWrapper(step: self)
    }

}

#endif
