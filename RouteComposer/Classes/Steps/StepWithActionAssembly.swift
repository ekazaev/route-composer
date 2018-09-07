//
// Created by Eugene Kazaev on 23/01/2018.
//

import Foundation
import UIKit

/// A simple protocol that produces intermediate `RoutingStep` for an assembly.
public class StepWithActionAssembly<F: Finder, FC: AbstractFactory> where F.ViewController == FC.ViewController, F.Context == FC.Context {

    var taskCollector: TaskCollector = TaskCollector()

    /// Adds routing interceptor instance
    ///
    /// - Parameter interceptor: The `RoutingInterceptor` instance to be executed by `Router` before routing
    ///   to this step.
    public final func add<R: RoutingInterceptor>(_ interceptor: R) -> Self {
        taskCollector.add(interceptor)
        return self
    }

    /// Adds generic context task instance. Generic means that it can be applied to any view controller with any type of context.
    /// Generic `ContextTask` must have the view controller type casted to `UIViewController` and context type casted  to `Any?`.
    ///
    /// - Parameter contextTask: The `ContextTask` instance to be executed by a `Router` immediately after it will find or create UIViewController.
    public final func add<CT: ContextTask>(_ contextTask: CT) -> Self where CT.ViewController == UIViewController, CT.Context == Any? {
        taskCollector.add(contextTask)
        return self
    }

    /// Adds context task instance
    ///
    /// - Parameter contextTask: The `ContextTask` instance to be executed by a `Router` immediately after it
    ///   will find or create UIViewController.
    public final func add<CT: ContextTask>(_ contextTask: CT) -> Self
            where
            CT.ViewController == FC.ViewController,
            CT.ViewController == F.ViewController,
            CT.Context == FC.Context,
            CT.Context == F.Context {
        taskCollector.add(contextTask)
        return self
    }

    /// Adds PostRoutingTask instance
    ///
    /// - Parameter postTask: The `PostRoutingTask` instance to be executed by a `Router` after routing to this step.
    public final func add<P: PostRoutingTask>(_ postTask: P) -> Self {
        taskCollector.add(postTask)
        return self
    }

    // Hides action integration from library user.
    func routingStep<A: Action>(with action: A) -> RoutingStep {
        fatalError("Must be overridden in a subclass")
    }

    // Hides action integration from library user.
    func embeddableRoutingStep<A: ContainerAction>(with action: A) -> RoutingStep {
        fatalError("Must be overridden in a subclass")
    }

}
