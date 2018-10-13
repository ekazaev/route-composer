//
// Created by Eugene Kazaev on 2018-09-17.
//

import Foundation
import UIKit

/// A wrapper for the general steps that can be applied to any `UIViewController`
public struct GeneralStep {

    struct RootViewControllerStep: RoutingStep, PerformableStep {

        /// Constructor
        init() {
        }

        func perform(with context: Any?) throws -> StepResult {
            guard let viewController = UIWindow.key?.rootViewController else {
                throw RoutingError.generic(RoutingError.Context(debugDescription: "Root view controller was not found."))
            }
            return .success(viewController)
        }

    }

    struct CurrentViewControllerStep: RoutingStep, PerformableStep {

        /// Constructor
        init() {
        }

        func perform(with context: Any?) throws -> StepResult {
            guard let viewController = UIWindow.key?.topmostViewController else {
                throw RoutingError.generic(RoutingError.Context(debugDescription: "Current view controller was not found."))
            }
            return .success(viewController)
        }

    }

    /// Returns the root view controller of the key window.
    public static func root<C>() -> DestinationStep<UIViewController, C> {
        return DestinationStep(RootViewControllerStep())
    }

    /// Returns the topmost presented view controller.
    public static func current<C>() -> DestinationStep<UIViewController, C> {
        return DestinationStep(CurrentViewControllerStep())
    }

}
