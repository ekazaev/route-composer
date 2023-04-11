//
// RouteComposer
// InlineStackIteratingFinder.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import UIKit

/// `InlineStackIteratingFinder`. Might be useful for the configuration testing.
public struct InlineStackIteratingFinder<VC: UIViewController, C>: StackIteratingFinder {

    // MARK: Associated types

    /// Type of `UIViewController` that `Factory` can build
    public typealias ViewController = VC

    /// `Context` to be passed into `UIViewController`
    public typealias Context = C

    // MARK: Properties

    public var iterator: StackIterator

    let inlineBock: (VC, C) -> Bool

    // MARK: Functions

    /// Constructor
    /// - Parameters:
    ///   - iterator: A `StackIterator` is to be used by `InlineStackIteratingFinder`
    ///   - inlineBock: A block to be called when `StackIteratingFinder.isTarget(...)` is requested.
    public init(iterator: StackIterator = RouteComposerDefaults.shared.stackIterator,
                _ inlineBock: @escaping (VC, C) -> Bool) {
        self.iterator = iterator
        self.inlineBock = inlineBock
    }

    public func isTarget(_ viewController: VC, with context: C) -> Bool {
        inlineBock(viewController, context)
    }

}

/// Extension to use `DefaultStackIterator` as default iterator.
public extension InlineStackIteratingFinder {

    /// Constructor
    ///
    /// - Parameters:
    ///   - options: A combination of the `SearchOptions`
    ///   - startingPoint: `DefaultStackIterator.StartingPoint` value
    ///   - windowProvider: `WindowProvider` instance.
    ///   - containerAdapterLocator: A `ContainerAdapterLocator` instance.
    ///   - inlineBock: A block to be called when `StackIteratingFinder.isTarget(...)` is requested.
    init(options: SearchOptions,
         startingPoint: DefaultStackIterator.StartingPoint = .topmost,
         windowProvider: WindowProvider = RouteComposerDefaults.shared.windowProvider,
         containerAdapterLocator: ContainerAdapterLocator = RouteComposerDefaults.shared.containerAdapterLocator,
         predicate inlineBock: @escaping (VC, C) -> Bool) {
        self.init(iterator: DefaultStackIterator(options: options, startingPoint: startingPoint, windowProvider: windowProvider, containerAdapterLocator: containerAdapterLocator), inlineBock)
    }

}
