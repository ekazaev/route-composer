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
        init(windowProvider: WindowProvider = KeyWindowProvider()) {
            self.windowProvider = windowProvider
        }

        func perform(with context: Any?) throws -> PerformableStepResult {
            guard let viewController = windowProvider.window?.rootViewController else {
                throw RoutingError.generic(.init("Root view controller was not found."))
            }
            return .success(viewController)
        }

    }

    struct CurrentViewControllerStep: RoutingStep, PerformableStep {

        let windowProvider: WindowProvider

        /// Constructor
        init(windowProvider: WindowProvider = KeyWindowProvider()) {
            self.windowProvider = windowProvider
        }

        func perform(with context: Any?) throws -> PerformableStepResult {
            guard let viewController = windowProvider.window?.topmostViewController else {
                throw RoutingError.generic(.init("Topmost view controller was not found."))
            }
            return .success(viewController)
        }

    }

    struct FinderStep: RoutingStep, PerformableStep {

        let finder: AnyFinder?

        init<F: Finder>(finder: F) {
            self.finder = FinderBox(finder)
        }

        func perform(with context: Any?) throws -> PerformableStepResult {
            guard let viewController = try finder?.findViewController(with: context) else {
                throw RoutingError.generic(.init("A view controller of \(String(describing: finder)) was not found."))
            }
            return .success(viewController)
        }
    }

    /// Returns the root view controller of the key window.
    public static func root<C>(windowProvider: WindowProvider = KeyWindowProvider()) -> DestinationStep<UIViewController, C> {
        return DestinationStep(RootViewControllerStep(windowProvider: windowProvider))
    }

    /// Returns the topmost presented view controller.
    public static func current<C>(windowProvider: WindowProvider = KeyWindowProvider()) -> DestinationStep<UIViewController, C> {
        return DestinationStep(CurrentViewControllerStep(windowProvider: windowProvider))
    }

    /// Returns the resulting view controller of the finder provided.
    public static func custom<F: Finder>(using finder: F) -> DestinationStep<F.ViewController, F.Context> {
        return DestinationStep(FinderStep(finder: finder))
    }

}
