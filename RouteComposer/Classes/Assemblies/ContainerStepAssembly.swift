//
// Created by Eugene Kazaev on 31/08/2018.
//

import Foundation
import UIKit

/// Builds a `RoutingStep` instance with the correct settings.
/// ### Keep in mind
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
public final class ContainerStepAssembly<F: Finder, FC: Container>: GenericStepAssembly<F, FC>, ActionConnecting
        where
        F.ViewController == FC.ViewController, F.Context == FC.Context {

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

    /// Connects previously provided `RoutingStep` instance with an `Action`
    ///
    /// - Parameter action: `Action` instance to be used with a step.
    /// - Returns: `ChainAssembly` to continue building the chain.
    public func using<A: Action>(_ action: A) -> StepChainAssembly<A.ViewController, ViewController, Context> {
        var previousSteps = self.previousSteps
        let step = BaseStep<ContainerFactoryBox<FC>>(
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
        let step = BaseStep<ContainerFactoryBox<FC>>(
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

public extension ContainerStepAssembly where FC: NilEntity {

    /// Created to remind user that factory that does not produce anything in most cases should
    /// be used with `NilAction`
    public func usingNoAction() -> StepChainAssembly<UIViewController, ViewController, Context> {
        return using(GeneralAction.nilAction())
    }

    public func integratedIn<AVC: ContainerViewController>() -> StepChainAssembly<AVC, ViewController, Context> {
        return using(GeneralAction.nilContainerAction() as UIViewController.NilAction<AVC>)
    }

}
