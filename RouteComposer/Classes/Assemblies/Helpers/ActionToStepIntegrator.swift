//
// Created by Eugene Kazaev on 23/01/2018.
//

import Foundation
import UIKit

/// A simple class that represents an intermediate `DestinationStep` and allows to add tasks to it.
public class ActionToStepIntegrator<F: Finder, FC: AbstractFactory>: InterceptableStepAssembling
        where F.ViewController == FC.ViewController, F.Context == FC.Context {

    public typealias ViewController = F.ViewController

    public typealias Context = F.Context

    var taskCollector: TaskCollector = TaskCollector()

    /// Adds `RoutingInterceptor` instance.
    /// This action does not contain type safety checks to avoid complications.
    ///
    /// - Parameter interceptor: The `RoutingInterceptor` instance to be executed by `Router` before the navigation process
    ///   to this step.
    public final func adding<R: RoutingInterceptor>(_ interceptor: R) -> Self where R.Context == Context {
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
    public final func adding<P: PostRoutingTask>(_ postTask: P) -> Self where P.Context == Context {
        taskCollector.add(postTask)
        return self
    }

    // Hides action integration from library user.
    func routingStep<A: Action>(with action: A) -> RoutingStep? {
        return nil
    }

    // Hides action integration from library user.
    func embeddableRoutingStep<A: ContainerAction>(with action: A) -> RoutingStep? {
        return nil
    }

}
