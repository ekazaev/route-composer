//
// Created by Eugene Kazaev on 23/01/2018.
//

import Foundation
import UIKit

/// A simple class that represents an intermediate `DestinationStep` and allows to add tasks to it.
public class ActionToStepIntegrator<VC: UIViewController, C>: InterceptableStepAssembling {

    public typealias ViewController = VC

    public typealias Context = C

    var taskCollector: TaskCollector

    init(taskCollector: TaskCollector = TaskCollector()) {
        self.taskCollector = taskCollector
    }
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

    // Hides action integration from library user.
    func routingStep<A: Action>(with action: A) -> RoutingStep? {
        return nil
    }

    // Hides action integration from library user.
    func embeddableRoutingStep<A: ContainerAction>(with action: A) -> RoutingStep? {
        return nil
    }

}
