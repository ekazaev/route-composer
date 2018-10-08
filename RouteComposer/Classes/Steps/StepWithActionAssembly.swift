//
// Created by Eugene Kazaev on 23/01/2018.
//

import Foundation
import UIKit

/// A simple class that represents an intermediate `DestinationStep` and allows to add tasks to it.
public class StepWithActionAssembly<F: Finder, FC: AbstractFactory>: InterceptableStepAssembling where F.ViewController == FC.ViewController, F.Context == FC.Context {

    public typealias ViewController = F.ViewController

    public typealias Context = F.Context

    var taskCollector: TaskCollector = TaskCollector()

    public final func add<R: RoutingInterceptor>(_ interceptor: R) -> Self where R.Context == Context {
        taskCollector.add(interceptor)
        return self
    }
    public final func add<CT: ContextTask>(_ contextTask: CT) -> Self
            where
            CT.ViewController == ViewController, CT.Context == Context {
        taskCollector.add(contextTask)
        return self
    }
    public final func add<P: PostRoutingTask>(_ postTask: P) -> Self where P.Context == Context {
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
