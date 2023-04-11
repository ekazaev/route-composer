//
// RouteComposer
// PresentingFinder.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import UIKit

/// `PresentingFinder` returns the presenting `UIViewController` of the topmost one in current stack.
public struct PresentingFinder<C>: Finder {

    // MARK: Internal entities

    /// A starting point in the `UIViewController`s stack
    ///
    /// - topmost: Start from the topmost `UIViewController`
    /// - custom: Start from the custom `UIViewController`
    public enum StartingPoint {

        /// Start from the topmost `UIViewController`
        case topmost

        /// Start from the custom `UIViewController`
        case custom(@autoclosure () throws -> UIViewController?)

    }

    // MARK: Properties

    /// `WindowProvider` instance.
    public let windowProvider: WindowProvider

    /// A starting point in the `UIViewController`s stack
    public let startingPoint: StartingPoint

    // MARK: Methods

    /// Constructor
    ///
    /// - Parameters:
    ///   - windowProvider: `WindowProvider` instance.
    ///   - startingPoint: `DefaultStackIterator.StartingPoint` value
    public init(windowProvider: WindowProvider = RouteComposerDefaults.shared.windowProvider,
                startingPoint: StartingPoint = .topmost) {
        self.windowProvider = windowProvider
        self.startingPoint = startingPoint
    }

    public func findViewController(with context: C) throws -> UIViewController? {
        try getStartingViewController()?.presentingViewController
    }

    func getStartingViewController() throws -> UIViewController? {
        switch startingPoint {
        case .topmost:
            return windowProvider.window?.topmostViewController
        case let .custom(viewControllerClosure):
            return try viewControllerClosure()
        }
    }

}
