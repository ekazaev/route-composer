//
// RouteComposer
// StepAssembler.swift
// https://github.com/ekazaev/route-composer
//
// Copyright (c) 2018-2025 Eugene Kazaev.
// Distributed under the MIT License.
//
// Modified in a fork by Savva Shuliatev
// https://github.com/Savva-Shuliatev
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import UIKit
import SwiftUI

/// Builds a `DestinationStep` instance with the correct settings into a chain of steps.
/// ### NB
/// Both `Finder` and `Factory` instances should deal with the same type of `UIViewController` and `Context` instances.
/// ### Usage
/// ```swift
/// let productScreen = StepAssembler<ProductViewController, ProductContext>()
///         .finder(.classWithContextFinder)
///         .factory(.storyboardFactory(name: "TabBar", identifier: "ProductViewController"))
///         .adding(ContextSettingTask())
///         .using(.push)
///         .from(.navigationController)
///         .using(.present)
///         .from(.current)
///         .assemble()
/// ```
@MainActor
public struct StepAssembler<VC: UIViewController, C> {

    // MARK: Methods

    public init() {}

    /// Sets a specific Finder instance
    ///
    /// - Parameters:
    ///   - finder: The `UIViewController` `Finder` instance.
    @_disfavoredOverload
    public func finder<F: Finder>(_ finder: F) -> StepAssemblerWithFinder<F> where F.ViewController == VC, F.Context == C {
        getFinder(finder)
    }

    /// Returns a StepAssemblerWithFinder configured with the provided Finder.
    ///
    /// A @_spi method to integrate custom shorthands for custom finders.
    ///
    /// - Parameters:
    ///   - finder: The custom (recommended) `UIViewController` `Finder` instance.
    ///
    /// Usage:
    /// ```swift
    /// @_spi(Advanced) import RouteComposer
    ///
    /// class ColorViewControllerFinder: StackIteratingFinder {...}
    ///
    /// extension ColorViewControllerFinder {
    ///     /// Shorthand to be used as `.using(.colorViewControllerFinder)`
    ///     static var colorViewControllerFinder: ColorViewControllerFinder { ColorViewControllerFinder() }
    /// }
    ///
    /// extension StepAssembler where VC == ColorViewController, C == String { // Add new finder method for shorthand .colorViewControllerFinder
    ///     func finder(_ finder: ColorViewControllerFinder) -> StepAssemblerWithFinder<ColorViewControllerFinder> {
    ///         return getFinder(finder) // Advanced method
    ///     }
    /// }
    ///
    /// var colorScreen: DestinationStep<ColorViewController, String> {
    ///     StepAssembler<ColorViewController, String>()
    ///         .finder(.colorViewControllerFinder) // Or you can call `.finder(ColorViewControllerFinder())`
    ///         ...
    ///         .assemble()
    /// }
    /// ```
    @_spi(Advanced)
    public func getFinder<F: Finder>(_ finder: F) -> StepAssemblerWithFinder<F> where F.ViewController == VC, F.Context == C {
        StepAssemblerWithFinder(finder: finder)
    }

}

// MARK: Shorthands

extension StepAssembler {

    public func finder(_ finder: ClassFinder<VC, C>) -> StepAssemblerWithFinder<ClassFinder<VC, C>> {
        getFinder(finder)
    }

    public func finder(_ finder: InstanceFinder<VC, C>) -> StepAssemblerWithFinder<InstanceFinder<VC, C>> {
        getFinder(finder)
    }

    public func finder(_ finder: NilFinder<VC, C>) -> StepAssemblerWithFinder<NilFinder<VC, C>> {
        getFinder(finder)
    }

    public func finder<ContentView: View & ContextChecking>(_ finder: UIHostingControllerWithContextFinder<ContentView>) -> StepAssemblerWithFinder<UIHostingControllerWithContextFinder<ContentView>> where UIHostingController<ContentView> == VC, ContentView.Context == C {
        getFinder(finder)
    }
}

extension StepAssembler where VC: ContextChecking, C == VC.Context {
    public func finder(_ finder: ClassWithContextFinder<VC, C>) -> StepAssemblerWithFinder<ClassWithContextFinder<VC, C>> {
            getFinder(finder)
      }
}
