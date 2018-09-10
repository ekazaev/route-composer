//
// Created by Eugene Kazaev on 31/08/2018.
//

import Foundation
import UIKit

/// Abstract builder class that helps to create a `RoutingStep` instance with correct settings.
public class GenericStepAssembly<F: Finder, FC: AbstractFactory>: InterceptableStepAssembling
        where F.ViewController == FC.ViewController, F.Context == FC.Context {

    public typealias ViewController = F.ViewController

    public typealias Context = F.Context

    var taskCollector: TaskCollector = TaskCollector()

    /// Adds routing interceptor instance.
    /// This action does not contain type safety checks to avoid complications.
    ///
    /// - Parameter interceptor: The `RoutingInterceptor` instance to be executed by `Router` before routing
    ///   to this step.
    public final func add<R: RoutingInterceptor>(_ interceptor: R) -> Self {
        taskCollector.add(interceptor)
        return self
    }

    /// Adds context task instance
    ///
    /// - Parameter contextTask: The `ContextTask` instance to be executed by a `Router` immediately after it
    ///   will find or create UIViewController.
    public final func add<CT: ContextTask>(_ contextTask: CT) -> Self
            where
            CT.ViewController == ViewController, CT.Context == Context {
        taskCollector.add(contextTask)
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

    /// Adds PostRoutingTask instance.
    /// This action does not contain type safety checks to avoid complications.
    ///
    /// - Parameter postTask: The `PostRoutingTask` instance to be executed by a `Router` after routing to this step.
    public final func add<P: PostRoutingTask>(_ postTask: P) -> Self {
        taskCollector.add(postTask)
        return self
    }

}
