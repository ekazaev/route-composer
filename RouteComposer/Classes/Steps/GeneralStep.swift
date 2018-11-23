//
// Created by Eugene Kazaev on 2018-09-17.
//

import Foundation
import UIKit

/// A wrapper for the general steps that can be applied to any `UIViewController`
public struct GeneralStep {

    struct RootViewControllerStep: RoutingStep, PerformableStep {

        let windowProvider: WindowProvider

        /// Constructor
        init(windowProvider: WindowProvider = DefaultWindowProvider()) {
            self.windowProvider = windowProvider
        }

        func perform(with context: Any?) throws -> PerformableStepResult {
            guard let viewController = windowProvider.window?.rootViewController else {
                throw RoutingError.generic(RoutingError.Context(debugDescription: "Root view controller was not found."))
            }
            return .success(viewController)
        }

    }

    struct CurrentViewControllerStep: RoutingStep, PerformableStep {

        let windowProvider: WindowProvider

        /// Constructor
        init(windowProvider: WindowProvider = DefaultWindowProvider()) {
            self.windowProvider = windowProvider
        }

        func perform(with context: Any?) throws -> PerformableStepResult {
            guard let viewController = windowProvider.window?.topmostViewController else {
                throw RoutingError.generic(RoutingError.Context(debugDescription: "Topmost view controller was not found."))
            }
            return .success(viewController)
        }

    }

    /// Returns the root view controller of the key window.
    public static func root<C>(windowProvider: WindowProvider = DefaultWindowProvider()) -> DestinationStep<UIViewController, C> {
        return DestinationStep(RootViewControllerStep(windowProvider: windowProvider))
    }

    /// Returns the topmost presented view controller.
    public static func current<C>(windowProvider: WindowProvider = DefaultWindowProvider()) -> DestinationStep<UIViewController, C> {
        return DestinationStep(CurrentViewControllerStep(windowProvider: windowProvider))
    }

}
