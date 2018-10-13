//
// Created by Eugene Kazaev on 05/02/2018.
//

import Foundation
import UIKit

/// Builds a `DestinationStep` instance with the correct settings into a chain of steps.
/// ### NB
/// Both `Finder` and `Factory` instances should deal with the same type of `UIViewController` and `Context` instances.
/// ### Usage
/// ```swift
/// let productScreen = StepAssembly(finder: ProductViewControllerFinder(), factory: ProductViewControllerFactory())
///         .add(LoginInterceptor())
///         .add(ProductViewControllerContextTask())
///         .add(ProductViewControllerPostTask(analyticsManager: AnalyticsManager.sharedInstance))
///         .using(PushToNavigationAction())
///         .from(NavigationControllerStep())
///         .using(DefaultActions.PresentModally())
///         .from(CurrentControllerStep())
///         .assemble()
/// ```
public final class StepAssembly<F: Finder, FC: Factory>: GenericStepAssembly<F.ViewController, F.Context>, ActionConnecting
        where F.ViewController == FC.ViewController, F.Context == FC.Context {

    let finder: F

    let factory: FC

    public typealias Context = F.Context

    let previousSteps: [RoutingStep]

    /// Constructor
    ///
    /// - Parameters:
    ///   - finder: The `UIViewController` `Finder` instance.
    ///   - factory: The `UIViewController` `Factory` instance.
    public init(finder: F, factory: FC) {
        self.factory = factory
        self.finder = finder
        self.previousSteps = []
    }

    public func using<A: Action>(_ action: A) -> StepChainAssembly<ViewController, Context> {
        var previousSteps = self.previousSteps
        let step = BaseStep<FactoryBox<FC>>(
                finder: self.finder,
                factory: self.factory,
                action: ActionBox(action),
                interceptor: taskCollector.interceptor(),
                contextTask: taskCollector.contextTask(),
                postTask: taskCollector.postTask())
        previousSteps.append(step)
        return StepChainAssembly(previousSteps: previousSteps)
    }

    public func using<A: ContainerAction>(_ action: A) -> ContainerStepChainAssembly<A.ViewController, ViewController, Context> {
        var previousSteps = self.previousSteps
        let step = BaseStep<FactoryBox<FC>>(
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
