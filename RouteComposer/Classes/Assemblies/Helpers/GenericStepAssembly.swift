//
// Created by Eugene Kazaev on 31/08/2018.
//

import Foundation
import UIKit

/// Abstract builder class that helps to create a `DestinationStep` instance with correct settings.
public class GenericStepAssembly<VC: UIViewController, C>: InterceptableStepAssembling {

    public typealias ViewController = VC

    public typealias Context = C

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

}
