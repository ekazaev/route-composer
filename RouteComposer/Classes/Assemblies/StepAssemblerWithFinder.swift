//
// RouteComposer
// StepAssemblerWithFinder.swift
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

/// Helper struct to build StepAssembly with chain StepAssembler -> StepAssemblerWithFinder -> StepAssembly.
@MainActor
public struct StepAssemblerWithFinder<F: Finder> {

    // MARK: Properties

    let finder: F

    // MARK: Methods

    public init(finder: F) {
        self.finder = finder
    }

    /// Return a StepAssembly from StepAssemblerWithFinder<F: Finder> with a specific `Factory` instance
    ///
    /// - Parameters:
    ///   - factory: The `UIViewController` `Factory` instance.
    @_disfavoredOverload
    public func factory<FC: Factory>(_ factory: FC) -> StepAssembly<F, FC> {
        getFactory(factory)
    }

    /// Return a StepAssembly from StepAssemblerWithFinder<F: Finder> with a specific `ContainerFactory` instance
    ///
    /// - Parameters:
    ///   - factory: The `UIViewController` `Factory` instance.
    @_disfavoredOverload
    public func factory<FC: ContainerFactory>(_ factory: FC) -> StepAssembly<F, FC> {
        getFactory(factory)
    }

    /// Returns a StepAssembly from StepAssemblerWithFinder<F: Finder> with a specific `Factory` instance
    ///
    /// A @_spi method to integrate custom shorthands for custom factory.
    ///
    /// - Parameters:
    ///   - factory: The `UIViewController` `Factory` instance.
    ///
    /// Usage:
    /// ```swift
    /// @_spi(Advanced) import RouteComposer
    ///
    /// class ColorViewControllerFactory: Factory {...}
    ///
    /// extension ColorViewControllerFactory {
    ///     /// Shorthand to be used as `.using(.colorViewControllerFactory)`
    ///     static var colorViewControllerFactory: ColorViewControllerFactory { ColorViewControllerFactory() }
    /// }
    ///
    /// extension StepAssemblerWithFinder where F.ViewController == ColorViewController, F.Context == String { // Add new factory method for shorthand .colorViewControllerFactory
    ///     func factory(_ factory: ColorViewControllerFactory) -> StepAssembly<F, ColorViewControllerFactory> {
    ///         return getFactory(factory)
    ///     }
    /// }
    ///
    /// var colorScreen: DestinationStep<ColorViewController, String> {
    ///     StepAssembler<ColorViewController, String>()
    ///         .finder(ColorViewControllerFinder())
    ///         .factory(.colorViewControllerFactory) // Or you can call `.factory(ColorViewControllerFactory())`
    ///         ...
    ///         .assemble()
    /// }
    /// ```
    @_spi(Advanced)
    public func getFactory<FC: Factory>(_ factory: FC) -> StepAssembly<F, FC> {
        StepAssembly(finder: finder, factory: factory)
    }

    @_spi(Advanced)
    public func getFactory<FC: ContainerFactory>(_ factory: FC) -> StepAssembly<F, FC> {
        StepAssembly(finder: finder, factory: factory)
    }

}

// MARK: Shorthands

extension StepAssemblerWithFinder {
    public func factory(_ factory: ClassFactory<F.ViewController, F.Context>) -> StepAssembly<F, ClassFactory<F.ViewController, F.Context>> {
        getFactory(factory)
    }

    public func factory<FC: Factory>(_ factory: FinderFactory<FC>) -> StepAssembly<F, FinderFactory<FC>> {
        getFactory(factory)
    }

    public func factory(_ factory: NilFactory<F.ViewController, F.Context>) -> StepAssembly<F, NilFactory<F.ViewController, F.Context>> {
        getFactory(factory)
    }

    public func factory(_ factory: StoryboardFactory<F.ViewController, F.Context>) -> StepAssembly<F, StoryboardFactory<F.ViewController, F.Context>> {
        getFactory(factory)
    }

    public func factory<ContentView: View & ContextChecking>(_ factory: UIHostingControllerFactory<ContentView, F.Context>)
        -> StepAssembly<F, UIHostingControllerFactory<ContentView, F.Context>> {
        getFactory(factory)
    }

    public func factory<ContentView: View & ContextChecking>(_ factory: UIHostingControllerWithContextFactory<ContentView>)
        -> StepAssembly<F, UIHostingControllerWithContextFactory<ContentView>> {
        getFactory(factory)
    }

}

extension StepAssemblerWithFinder where F.ViewController == UINavigationController {
    public func factory(_ factory: NavigationControllerFactory<F.ViewController, F.Context>) -> StepAssembly<F, NavigationControllerFactory<F.ViewController, F.Context>> {
        getFactory(factory)
    }
}

extension StepAssemblerWithFinder where F.ViewController == UISplitViewController {
    public func factory(_ factory: SplitControllerFactory<F.ViewController, F.Context>) -> StepAssembly<F, SplitControllerFactory<F.ViewController, F.Context>> {
        getFactory(factory)
    }
}

extension StepAssemblerWithFinder where F.ViewController == UITabBarController {
    public func factory(_ factory: TabBarControllerFactory<F.ViewController, F.Context>) -> StepAssembly<F, TabBarControllerFactory<F.ViewController, F.Context>> {
        getFactory(factory)
    }
}
