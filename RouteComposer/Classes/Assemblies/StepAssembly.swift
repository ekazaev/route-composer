//
// Created by Eugene Kazaev on 05/02/2018.
//

import Foundation
import UIKit

/// Builder class that helps to create a `RoutingStep` instance with correct settings.
/// ### Keep in mind
/// Both `Finder` and `Factory` instances should deal with same type of `UIViewController` and `Context` instances.
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
public final class StepAssembly<F: Finder, FC: Factory>: GenericStepAssembly<F, FC>, Usable where F.ViewController == FC.ViewController, F.Context == FC.Context {

    let finder: F

    let factory: FC

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

    public func using(_ action: Action) -> ChainAssembly {
        var previousSteps = self.previousSteps
        let step = FinalRoutingStep<FactoryBox<FC>>(
                finder: self.finder,
                factory: self.factory,
                action: action,
                interceptor: taskCollector.interceptor(),
                contextTask: taskCollector.contextTask(),
                postTask: taskCollector.postTask(),
                previousStep: nil)
        previousSteps.append(step)
        return ChainAssembly(previousSteps: previousSteps)
    }

}

public extension StepAssembly where FC: NilEntity {

    /// Created to remind user that factory that does not produce anything in most cases should
    /// be used with `NilAction`
    public func usingNoAction() -> ChainAssembly {
        return using(GeneralAction.NilAction())
    }

}
