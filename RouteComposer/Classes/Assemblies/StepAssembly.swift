//
// Created by Eugene Kazaev on 05/02/2018.
//

import Foundation
import UIKit

/// Builds a `RoutingStep` instance with the correct settings.
/// ### Keep in mind
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
public final class StepAssembly<F: Finder, FC: Factory>: GenericStepAssembly<F, FC>, ActionConnecting
        where
        F.ViewController == FC.ViewController, F.Context == FC.Context {

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

    /// Connects previously provided `RoutingStep` instance with an `Action`
    ///
    /// - Parameter action: `Action` instance to be used with a step.
    /// - Returns: `ChainAssembly` to continue building the chain.
    public func using<A: Action>(_ action: A) -> StepChainAssembly<A.ViewController, ViewController, Context> {
        var previousSteps = self.previousSteps
        let step = BaseStep<FactoryBox<FC>>(
                finder: self.finder,
                factory: self.factory,
                action: ActionBox(action),
                interceptor: taskCollector.interceptor(),
                contextTask: taskCollector.contextTask(),
                postTask: taskCollector.postTask(),
                previousStep: nil)
        previousSteps.append(step)
        return StepChainAssembly(previousSteps: previousSteps)
    }

    /// Connects previously provided `RoutingStep` instance with an `Action`
    ///
    /// - Parameter action: `ContainerAction` instance to be used with a step.
    /// - Returns: `ChainAssembly` to continue building the chain.
    public func using<A: ContainerAction>(_ action: A) -> StepChainAssembly<A.ViewController, ViewController, Context> {
        var previousSteps = self.previousSteps
        let step = BaseStep<FactoryBox<FC>>(
                finder: self.finder,
                factory: self.factory,
                action: ContainerActionBox(action),
                interceptor: taskCollector.interceptor(),
                contextTask: taskCollector.contextTask(),
                postTask: taskCollector.postTask(),
                previousStep: nil)
        previousSteps.append(step)
        return StepChainAssembly(previousSteps: previousSteps)
    }

}

public extension StepAssembly where FC: NilEntity {

    /// Created to remind user that factory that does not produce anything in most cases should
    /// be used with `NilAction`
    public func usingNoAction() -> StepChainAssembly<UIViewController, ViewController, Context> {
        return using(GeneralAction.nilAction())
    }

    public func integratedIn<AVC: ContainerViewController>() -> StepChainAssembly<AVC, ViewController, Context> {
        return using(GeneralAction.nilContainerAction() as UIViewController.NilAction<AVC>)
    }

}
