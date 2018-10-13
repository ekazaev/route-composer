//
// Created by Eugene Kazaev on 31/08/2018.
//

import Foundation
import UIKit

/// Builds a `DestinationStep` instance with the correct settings into a chain of steps.
/// ### NB:
/// Both `Finder` and `Factory` instances should deal with the same type of `UIViewController` and `Context` instances.
/// ### Usage
/// ```swift
/// let containerScreen = ContainerStepAssembly(finder: ClassFinder(), factory: NavigationControllerFactory())
///         .add(LoginInterceptor())
///         .add(ProductViewControllerContextTask())
///         .add(ProductViewControllerPostTask(analyticsManager: AnalyticsManager.sharedInstance))
///         .using(GeneralAction.PresentModally())
///         .from(CurrentControllerStep())
///         .assemble()
/// ```
public final class ContainerStepAssembly<F: Finder, FC: Container>: GenericStepAssembly<F.ViewController, F.Context>, ActionConnecting
        where F.ViewController == FC.ViewController, F.Context == FC.Context {

    let finder: F

    let factory: FC

    let previousSteps: [RoutingStep]

    /// Constructor
    ///
    /// - Parameters:
    ///   - finder: The `UIViewController` `Finder` instance.
    ///   - factory: The `UIViewController` `Container` instance.
    public init(finder: F, factory: FC) {
        self.factory = factory
        self.finder = finder
        self.previousSteps = []
    }

    /// Connects previously provided `DestinationStep` instance with an `Action`
    ///
    /// - Parameter action: `Action` instance to be used with a step.
    public func using<A: Action>(_ action: A) -> StepChainAssembly<ViewController, Context> {
        var previousSteps = self.previousSteps
        let step = BaseStep<ContainerFactoryBox<FC>>(
                finder: self.finder,
                factory: self.factory,
                action: ActionBox(action),
                interceptor: taskCollector.interceptor(),
                contextTask: taskCollector.contextTask(),
                postTask: taskCollector.postTask())
        previousSteps.append(step)
        return StepChainAssembly(previousSteps: previousSteps)
    }

    /// Connects previously provided `DestinationStep` instance with an `Action`
    ///
    /// - Parameter action: `ContainerAction` instance to be used with a step.
    public func using<A: ContainerAction>(_ action: A) -> ContainerStepChainAssembly<A.ViewController, ViewController, Context> {
        var previousSteps = self.previousSteps
        let step = BaseStep<ContainerFactoryBox<FC>>(
                finder: self.finder,
                factory: self.factory,
                action: ContainerActionBox(action),
                interceptor: taskCollector.interceptor(),
                contextTask: taskCollector.contextTask(),
                postTask: taskCollector.postTask())
        previousSteps.append(step)
        return ContainerStepChainAssembly(previousSteps: previousSteps)
    }

}
