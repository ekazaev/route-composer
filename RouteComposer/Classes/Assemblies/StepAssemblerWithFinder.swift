//
// RouteComposer
// StepAssemblerWithFinder.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2026.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import SwiftUI
import UIKit

/// Helper struct to build StepAssembly with chain StepAssembler -> StepAssemblerWithFinder -> StepAssembly.
@MainActor
public struct StepAssemblerWithFinder<F: Finder> {

    // MARK: Properties

    let finder: F

    // MARK: Methods

    /// Constructor
    ///
    /// - Parameters:
    ///   - finder: The `UIViewController` `Finder` instance.
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

    /// Returns a StepAssembly from StepAssemblerWithFinder<F: Finder> with a specific `Factory` instance
    ///
    /// A @_spi method to integrate custom shorthands for custom factory.
    ///
    /// - Parameters:
    ///   - factory: The `UIViewController` `ContainerFactory` instance.
    ///
    @_spi(Advanced)
    public func getFactory<FC: ContainerFactory>(_ factory: FC) -> StepAssembly<F, FC> {
        StepAssembly(finder: finder, factory: factory)
    }

}

// MARK: Shorthands

public extension StepAssemblerWithFinder {
    /// Shorthand for different types of factories.
    func factory(_ factory: ClassFactory<F.ViewController, F.Context>) -> StepAssembly<F, ClassFactory<F.ViewController, F.Context>> {
        getFactory(factory)
    }

    /// Shorthand for different types of factories.
    func factory<FC: Factory>(_ factory: FinderFactory<FC>) -> StepAssembly<F, FinderFactory<FC>> {
        getFactory(factory)
    }

    /// Shorthand for different types of factories.
    func factory(_ factory: NilFactory<F.ViewController, F.Context>) -> StepAssembly<F, NilFactory<F.ViewController, F.Context>> {
        getFactory(factory)
    }

    /// Shorthand for different types of factories.
    func factory(_ factory: StoryboardFactory<F.ViewController, F.Context>) -> StepAssembly<F, StoryboardFactory<F.ViewController, F.Context>> {
        getFactory(factory)
    }

    /// Shorthand for different types of factories.
    func factory<ContentView: View & ContextChecking>(_ factory: UIHostingControllerFactory<ContentView, F.Context>)
    -> StepAssembly<F, UIHostingControllerFactory<ContentView, F.Context>> {
        getFactory(factory)
    }

    /// Shorthand for different types of factories.
    func factory<ContentView: View & ContextChecking>(_ factory: UIHostingControllerWithContextFactory<ContentView>)
    -> StepAssembly<F, UIHostingControllerWithContextFactory<ContentView>> {
        getFactory(factory)
    }

}

public extension StepAssemblerWithFinder where F.ViewController == UINavigationController {
    /// Shorthand for different types of factories.
    func factory(_ factory: NavigationControllerFactory<F.ViewController, F.Context>) -> StepAssembly<F, NavigationControllerFactory<F.ViewController, F.Context>> {
        getFactory(factory)
    }
}

public extension StepAssemblerWithFinder where F.ViewController == UISplitViewController {
    /// Shorthand for different types of factories.
    func factory(_ factory: SplitControllerFactory<F.ViewController, F.Context>) -> StepAssembly<F, SplitControllerFactory<F.ViewController, F.Context>> {
        getFactory(factory)
    }
}

public extension StepAssemblerWithFinder where F.ViewController == UITabBarController {
    /// Shorthand for different types of factories.
    func factory(_ factory: TabBarControllerFactory<F.ViewController, F.Context>) -> StepAssembly<F, TabBarControllerFactory<F.ViewController, F.Context>> {
        getFactory(factory)
    }
}
