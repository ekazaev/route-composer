//
// RouteComposer
// ActionToStepIntegrator.swift
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

// This class is only needed not to expose `RoutingStep` as public.
/// A simple class that represents an intermediate `DestinationStep` and allows to add tasks to it.
public class IntermediateDestinationStep {

    // Hides action integration from library user.
    func routingStep(with action: some Action) -> RoutingStep? {
        nil
    }

    // Hides action integration from library user.
    func embeddableRoutingStep(with action: some ContainerAction) -> RoutingStep? {
        nil
    }

}

/// Allows to add tasks to the step that is hidden in `IntermediateDestinationStep`.
public class ActionToStepIntegrator<VC: UIViewController, C>: IntermediateDestinationStep, InterceptableStepAssembling {

    // MARK: Associated types

    public typealias ViewController = VC

    public typealias Context = C

    // MARK: Properties

    var taskCollector: TaskCollector

    // MARK: Methods

    init(taskCollector: TaskCollector = TaskCollector()) {
        self.taskCollector = taskCollector
    }

    // MARK: Add a Task to the Step

    /// Adds `RoutingInterceptor` instance.
    /// This action does not contain type safety checks to avoid complications.
    ///
    /// - Parameter interceptor: The `RoutingInterceptor` instance to be executed by `Router` before the navigation process
    ///   to this step.
    public final func adding<RI: RoutingInterceptor>(_ interceptor: RI) -> Self where RI.Context == Context {
        taskCollector.add(interceptor)
        return self
    }

    /// Adds `ContextTask` instance
    ///
    /// - Parameter contextTask: The `ContextTask` instance to be applied by a `Router` immediately after it
    ///   will find or create `UIViewController`.
    public final func adding<CT: ContextTask>(_ contextTask: CT) -> Self
        where
        CT.ViewController == ViewController, CT.Context == Context {
        taskCollector.add(contextTask)
        return self
    }

    /// Adds `PostRoutingTask` instance.
    /// This action does not contain type safety checks to avoid complications.
    ///
    /// - Parameter postTask: The `PostRoutingTask` instance to be executed by a `Router` after the navigation process.
    public final func adding<PT: PostRoutingTask>(_ postTask: PT) -> Self where PT.Context == Context {
        taskCollector.add(postTask)
        return self
    }

}
