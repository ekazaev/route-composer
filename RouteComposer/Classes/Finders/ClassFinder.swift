//
// RouteComposer
// ClassFinder.swift
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

/// A default implementation of the view controllers finder that searches for a view controller by its name.
@MainActor
public struct ClassFinder<VC: UIViewController, C>: StackIteratingFinder {

    // MARK: Associated types

    public typealias ViewController = VC

    public typealias Context = C

    // MARK: Properties

    /// A `StackIterator` is to be used by `ClassFinder`
    public let iterator: StackIterator

    // MARK: Methods

    /// Constructor
    ///
    /// - Parameter iterator: A `StackIterator` is to be used by `ClassFinder`
    public init(iterator: StackIterator = RouteComposerDefaults.shared.stackIterator) {
        self.iterator = iterator
    }

    public func isTarget(_ viewController: VC, with context: C) -> Bool {
        true
    }

}

/// Extension to use `DefaultStackIterator` as default iterator.
@MainActor
public extension ClassFinder {

    /// Constructor
    ///
    /// Parameters
    ///   - options: A combination of the `SearchOptions`
    ///   - startingPoint: `DefaultStackIterator.StartingPoint` value
    ///   - windowProvider: `WindowProvider` instance.
    ///   - containerAdapterLocator: A `ContainerAdapterLocator` instance.
    init(options: SearchOptions,
         startingPoint: DefaultStackIterator.StartingPoint = .topmost,
         windowProvider: WindowProvider = RouteComposerDefaults.shared.windowProvider,
         containerAdapterLocator: ContainerAdapterLocator = RouteComposerDefaults.shared.containerAdapterLocator) {
        self.iterator = DefaultStackIterator(options: options, startingPoint: startingPoint, windowProvider: windowProvider, containerAdapterLocator: containerAdapterLocator)
    }

}

// MARK: Shorthands

public extension ClassFinder {

    /// A default implementation of the view controllers finder that searches for a view controller by its name.
    ///
    /// - Parameter iterator: A `StackIterator` is to be used by `ClassFinder`
    static func classFinder(iterator: StackIterator = RouteComposerDefaults.shared.stackIterator) -> Self {
        Self(iterator: iterator)
    }

    /// A default implementation of the view controllers finder that searches for a view controller by its name.
    static var classFinder: Self { .classFinder() }

    /// A default implementation of the view controllers finder that searches for a view controller by its name.
    ///
    /// Parameters
    ///   - options: A combination of the `SearchOptions`
    ///   - startingPoint: `DefaultStackIterator.StartingPoint` value
    ///   - windowProvider: `WindowProvider` instance.
    ///   - containerAdapterLocator: A `ContainerAdapterLocator` instance.
    static func classFinder(options: SearchOptions,
                            startingPoint: DefaultStackIterator.StartingPoint = .topmost,
                            windowProvider: WindowProvider = RouteComposerDefaults.shared.windowProvider,
                            containerAdapterLocator: ContainerAdapterLocator = RouteComposerDefaults.shared.containerAdapterLocator) -> Self {
        Self(options: options, startingPoint: startingPoint, windowProvider: windowProvider, containerAdapterLocator: containerAdapterLocator)
    }
}
