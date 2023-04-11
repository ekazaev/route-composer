//
// RouteComposer
// Finder.swift
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

/// An instance that conforms to the `Finder` protocol will be used by the `Router` to find out if some `UIViewController`
/// instance is integrated into the view controller stack
public protocol Finder {

    // MARK: Associated types

    /// Type of `UIViewController` that `Finder` can find
    associatedtype ViewController: UIViewController

    /// Type of `Context` object that `Finder` can deal with
    associatedtype Context

    // MARK: Methods to implement

    /// Returns the view controller instance if it is present in the stack.
    ///
    /// - Parameter context: The `Context` instance passed to the `Router`.
    /// - Returns: The `UIViewController` instance that the `Router` is looking for, nil otherwise.
    func findViewController(with context: Context) throws -> ViewController?

}

// MARK: Helper methods

public extension Finder {

    /// Returns the view controller instance if it is present in the stack. Doesn't throw any exceptions in case the search
    /// can not be performed.
    ///
    /// - Parameter context: The `Context` instance passed to the `Router`.
    /// - Returns: The `UIViewController` instance that the `Router` is looking for, nil otherwise.
    func getViewController(with context: Context) -> ViewController? {
        guard let viewController = try? findViewController(with: context) else {
            return nil
        }

        return viewController
    }

}

// MARK: Helper methods where the Context is Any?

public extension Finder where Context == Any? {

    /// Returns the view controller instance if it is present in the stack.
    ///
    /// - Returns: The `UIViewController` instance that the `Router` is looking for, nil otherwise.
    func findViewController() throws -> ViewController? {
        try findViewController(with: nil)
    }

    /// Returns the view controller instance if it is present in the stack. Doesn't throw any exceptions in case the search
    /// can not be performed.
    ///
    /// - Returns: The `UIViewController` instance that the `Router` is looking for, nil otherwise.
    func getViewController() -> ViewController? {
        getViewController(with: nil)
    }

}

// MARK: Helper methods where the Context is Void

public extension Finder where Context == Void {

    /// Returns the view controller instance if it is present in the stack.
    ///
    /// - Returns: The `UIViewController` instance that the `Router` is looking for, nil otherwise.
    func findViewController() throws -> ViewController? {
        try findViewController(with: ())
    }

    /// Returns the view controller instance if it is present in the stack. Doesn't throw any exceptions in case the search
    /// can not be performed.
    ///
    /// - Returns: The `UIViewController` instance that the `Router` is looking for, nil otherwise.
    func getViewController() -> ViewController? {
        getViewController(with: ())
    }

}
