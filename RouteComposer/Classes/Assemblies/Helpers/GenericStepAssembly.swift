//
// Created by Eugene Kazaev on 31/08/2018.
//

import Foundation
import UIKit

/// Abstract builder class that helps to create a `DestinationStep` instance with correct settings.
public class GenericStepAssembly<F: Finder, FC: AbstractFactory>: InterceptableStepAssembling
        where F.ViewController == FC.ViewController, F.Context == FC.Context {

    public typealias ViewController = F.ViewController

    public typealias Context = F.Context

    var taskCollector: TaskCollector = TaskCollector()

    /// Adds navigation interceptor instance.
    /// This action does not contain type safety checks to avoid complications.
    ///
    /// - Parameter interceptor: The `RoutingInterceptor` instance to be executed by `Router` before routing
    ///   to this step.
    public final func add<R: RoutingInterceptor>(_ interceptor: R) -> Self where R.Context == Context {
        taskCollector.add(interceptor)
        return self
    }

    /// Adds context task instance
    ///
    /// - Parameter contextTask: The `ContextTask` instance to be applied by a `Router` immediately after it
    ///   will find or create a `UIViewController`.
    public final func add<CT: ContextTask>(_ contextTask: CT) -> Self
            where
            CT.ViewController == ViewController, CT.Context == Context {
        taskCollector.add(contextTask)
        return self
    }

    /// Adds PostRoutingTask instance.
    /// This action does not contain type safety checks to avoid complications.
    ///
    /// - Parameter postTask: The `PostRoutingTask` instance to be executed by a `Router` after routing to this step.
    public final func add<P: PostRoutingTask>(_ postTask: P) -> Self where P.Context == Context {
        taskCollector.add(postTask)
        return self
    }

}
