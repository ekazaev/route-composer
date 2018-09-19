//
// Created by Eugene Kazaev on 2018-09-17.
//

import Foundation
import UIKit

/// Just a wrapper for the general steps that can be applied to any `UIViewController`
public struct GeneralStep {

    /// Returns the root view controller of the key window.
    public static func root() -> DestinationStep<UIViewController, Any?> {

        struct RootViewControllerStep: RoutingStep, PerformableStep {

            /// Constructor
            public init() {
            }

            func perform(for context: Any?) -> StepResult {
                return StepResult(UIWindow.key?.rootViewController)
            }

        }

        return DestinationStep(RootViewControllerStep())
    }

    /// Returns the topmost presented view controller.
    public static func current() -> DestinationStep<UIViewController, Any?> {

        struct CurrentViewControllerStep: RoutingStep, PerformableStep {

            /// Constructor
            public init() {
            }

            func perform(for context: Any?) -> StepResult {
                let window = UIWindow.key
                return StepResult(window?.topmostViewController)
            }

        }

        return DestinationStep(CurrentViewControllerStep())
    }

}
