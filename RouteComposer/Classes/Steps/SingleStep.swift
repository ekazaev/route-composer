//
// RouteComposer
// SingleStep.swift
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

/// A simple class that produces an intermediate `ActionToStepIntegrator` describing any view controller.
public final class SingleStep<F: Finder, FC: Factory>: ActionToStepIntegrator<F.ViewController, F.Context>
    where
    F.ViewController == FC.ViewController, F.Context == FC.Context {

    // MARK: Internal entities

    final class UnsafeWrapper<VC: UIViewController, C, F: Finder, FC: Factory>: ActionToStepIntegrator<VC, C>
        where
        F.ViewController == FC.ViewController, F.Context == FC.Context {

        final let step: SingleStep<F, FC>

        init(step: SingleStep<F, FC>) {
            self.step = step
            super.init(taskCollector: step.taskCollector)
        }

        final override func routingStep(with action: some Action) -> RoutingStep? {
            step.routingStep(with: action)
        }

        final override func embeddableRoutingStep(with action: some ContainerAction) -> RoutingStep? {
            step.embeddableRoutingStep(with: action)
        }

    }

    // MARK: Properties

    final let finder: F

    final let factory: FC

    // MARK: Methods

    /// A simple class that produces an intermediate `ActionToStepIntegrator`.
    ///
    /// - Parameters:
    ///   - finder: The `UIViewController` `Finder`.
    ///   - factory: The `UIViewController` `Factory`.
    public init(finder: F, factory: FC) {
        self.finder = finder
        self.factory = factory
    }

    final override func routingStep(with action: some Action) -> RoutingStep {
        let entitiesCollector = BaseEntitiesCollector<FactoryBox<FC>, ActionBox>(finder: finder, factory: factory, action: action)
        return BaseStep(entitiesProvider: entitiesCollector, taskProvider: taskCollector)
    }

    final override func embeddableRoutingStep(with action: some ContainerAction) -> RoutingStep {
        let entitiesCollector = BaseEntitiesCollector<FactoryBox<FC>, ContainerActionBox>(finder: finder, factory: factory, action: action)
        return BaseStep(entitiesProvider: entitiesCollector, taskProvider: taskCollector)
    }

    /// Adapts context and view controller type dependencies.
    ///
    /// *NB:* Developer guaranties that this types will compliment in runtime.
    public final func unsafelyRewrapped<VC: UIViewController, C>() -> ActionToStepIntegrator<VC, C> {
        UnsafeWrapper(step: self)
    }

    /// Allows to avoid container view controller check.
    ///
    /// *NB:* Developer guaranties that it will be there in the runtime.
    public final func expectingContainer<VC: ContainerViewController>() -> ActionToStepIntegrator<VC, F.Context> {
        UnsafeWrapper(step: self)
    }

}

// MARK: Helper methods where the Context is Any?

public extension SingleStep where FC.Context == Any? {

    /// Allows to avoid container view controller check. This method is available only for the steps that are
    /// able to accept any type of context.
    ///
    /// *NB:* Developer guaranties that it will be there in the runtime.
    final func expectingContainer<VC: ContainerViewController, C>() -> ActionToStepIntegrator<VC, C> {
        UnsafeWrapper(step: self)
    }

    /// Allows to compliment to the type check. A step that has context equal to Optional(Any) can be build
    /// with any type of context passed to the router.
    final func adaptingContext<C>() -> ActionToStepIntegrator<F.ViewController, C> {
        UnsafeWrapper(step: self)
    }

}
