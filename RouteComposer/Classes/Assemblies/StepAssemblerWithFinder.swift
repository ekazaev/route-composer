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

@MainActor
public struct StepAssemblerWithFinder<F: Finder> {

    let finder: F

    public init(finder: F) {
        self.finder = finder
    }

    @_disfavoredOverload
    public func factory<FC: Factory>(_ factory: FC) -> StepAssembly<F, FC> {
        getFactory(factory)
    }

    @_disfavoredOverload
    public func factory<FC: ContainerFactory>(_ factory: FC) -> StepAssembly<F, FC> {
        getFactory(factory)
    }

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

    public func factory<ContentView: View & ContextChecking>(_ factory: UIHostingControllerFactory<ContentView, F.Context>) -> StepAssembly<F, UIHostingControllerFactory<ContentView, F.Context>> {
        getFactory(factory)
    }

    public func factory<ContentView: View & ContextChecking>(_ factory: UIHostingControllerWithContextFactory<ContentView>) -> StepAssembly<F, UIHostingControllerWithContextFactory<ContentView>> {
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
