//
// Created by Eugene Kazaev on 2018-09-17.
//

import Foundation
import UIKit

//
public struct GeneralStep {

    /// Returns the root view controller of the key window.
    public static func root() -> DestinationStep<Any?> {

        struct RootViewControllerStep: RoutingStep, PerformableStep {

            /// Constructor
            public init() {
            }

            func perform(for destination: Any?) -> StepResult {
                return StepResult(UIWindow.key?.rootViewController)
            }

        }

        return DestinationStep(RootViewControllerStep())
    }

    /// Returns the topmost presented view controller.
    public static func current() -> DestinationStep<Any?> {

        struct CurrentViewControllerStep: RoutingStep, PerformableStep {

            /// Constructor
            public init() {
            }

            func perform(for destination: Any?) -> StepResult {
                let window = UIWindow.key
                return StepResult(window?.topmostViewController)
            }

        }

        return DestinationStep(CurrentViewControllerStep())
    }

}
