//
// RouteComposer
// GeneralStep.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2025.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import UIKit

/// A wrapper for the general steps that can be applied to any `UIViewController`
public enum GeneralStep {

    // MARK: Internal entities

    struct RootViewControllerStep: RoutingStep, PerformableStep {

        let windowProvider: WindowProvider

        /// Constructor
        init(windowProvider: WindowProvider = RouteComposerDefaults.shared.windowProvider) {
            self.windowProvider = windowProvider
        }

        func perform(with context: AnyContext) throws -> PerformableStepResult {
            guard let viewController = windowProvider.window?.rootViewController else {
                throw RoutingError.compositionFailed(.init("Root view controller was not found."))
            }
            return .success(viewController)
        }

    }

    struct CurrentViewControllerStep: RoutingStep, PerformableStep {

        let windowProvider: WindowProvider

        /// Constructor
        init(windowProvider: WindowProvider = RouteComposerDefaults.shared.windowProvider) {
            self.windowProvider = windowProvider
        }

        func perform(with context: AnyContext) throws -> PerformableStepResult {
            guard let viewController = windowProvider.window?.topmostViewController else {
                throw RoutingError.compositionFailed(.init("Topmost view controller was not found."))
            }
            return .success(viewController)
        }

    }

    struct FinderStep: RoutingStep, PerformableStep {

        let finder: AnyFinder?

        init(finder: some Finder) {
            self.finder = FinderBox(finder)
        }

        func perform(with context: AnyContext) throws -> PerformableStepResult {
            guard let viewController = try finder?.findViewController(with: context) else {
                throw RoutingError.compositionFailed(.init("A view controller of \(String(describing: finder)) was not found."))
            }
            return .success(viewController)
        }
    }

    // MARK: Steps

    /// Returns the root view controller of the key window.
    @MainActor
    public static func root<C>(windowProvider: WindowProvider = RouteComposerDefaults.shared.windowProvider) -> DestinationStep<UIViewController, C> {
        DestinationStep(RootViewControllerStep(windowProvider: windowProvider))
    }

    /// Returns the topmost presented view controller.
    @MainActor
    public static func current<C>(windowProvider: WindowProvider = RouteComposerDefaults.shared.windowProvider) -> DestinationStep<UIViewController, C> {
        DestinationStep(CurrentViewControllerStep(windowProvider: windowProvider))
    }

    /// Returns the resulting view controller of the finder provided.
    @MainActor
    public static func custom<F: Finder>(using finder: F) -> DestinationStep<F.ViewController, F.Context> {
        DestinationStep(FinderStep(finder: finder))
    }

}

// MARK: Shorthands

public extension DestinationStep where VC == UIViewController {
    /// Shorthand to be used as `.from(.root(...))`
    static func root<NewContext>(windowProvider: WindowProvider = RouteComposerDefaults.shared.windowProvider) -> DestinationStep<UIViewController, NewContext> {
        GeneralStep.root(windowProvider: windowProvider)
    }

    /// Shorthand to be used as `.from(.root)`
    static var root: DestinationStep<UIViewController, C> { root() }

    /// Shorthand to be used as `.from(.current(...))`
    static func current<NewContext>(windowProvider: WindowProvider = RouteComposerDefaults.shared.windowProvider) -> DestinationStep<UIViewController, NewContext> {
        GeneralStep.current(windowProvider: windowProvider)
    }

    /// Shorthand to be used as `.from(.current)`
    static var current: DestinationStep<UIViewController, C> { current() }

    /// Shorthand to be used as `.from(.custom(...))`
    static func custom<F: Finder>(using finder: F) -> DestinationStep<F.ViewController, F.Context> {
        GeneralStep.custom(using: finder)
    }
}

public extension ActionToStepIntegrator where VC == UIViewController {
    /// Shorthand to be used as `.from(.root(...))`
    static func root<NewContext>(windowProvider: WindowProvider = RouteComposerDefaults.shared.windowProvider) -> DestinationStep<UIViewController, NewContext> {
        GeneralStep.root(windowProvider: windowProvider)
    }

    /// Shorthand to be used as `.from(.root)`
    static var root: DestinationStep<UIViewController, C> { root() }

    /// Shorthand to be used as `.from(.current(...))`
    static func current<NewContext>(windowProvider: WindowProvider = RouteComposerDefaults.shared.windowProvider) -> DestinationStep<UIViewController, NewContext> {
        GeneralStep.current(windowProvider: windowProvider)
    }

    /// Shorthand to be used as `.from(.current)`
    static var current: DestinationStep<UIViewController, C> { current() }

    /// Shorthand to be used as `.from(.custom(...))`
    static func custom<F: Finder>(using finder: F) -> DestinationStep<F.ViewController, F.Context> {
        GeneralStep.custom(using: finder)
    }
}
