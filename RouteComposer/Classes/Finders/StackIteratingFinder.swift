//
// RouteComposer
// StackIteratingFinder.swift
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

/// `StackIteratingFinder` iterates through the view controllers stack
/// following the search options provided. It simplifies the creation of the finders for a hosting app.
public protocol StackIteratingFinder: Finder {

    // MARK: Associated types

    /// Type of `UIViewController` that `StackIteratingFinder` can find
    associatedtype ViewController

    /// Type of `Context` object that `StackIteratingFinder` can deal with
    associatedtype Context

    // MARK: Properties to implement

    /// `StackIterator` to be used by `StackIteratingFinder`
    var iterator: StackIterator { get }

    // MARK: Methods to implement

    /// The method to be implemented by the `StackIteratingFinder` instance
    ///
    /// - Parameters:
    ///   - viewController: A view controller in the current view controller stack
    ///   - context: The `Context` instance provided to the `Router`.
    /// - Returns: true if this view controller is the one that `Finder` is looking for, false otherwise.
    func isTarget(_ viewController: ViewController,
                  with context: Context) -> Bool

}

public extension StackIteratingFinder {

    func findViewController(with context: Context) throws -> ViewController? {
        let predicate: (UIViewController) -> Bool = {
            guard let viewController = $0 as? ViewController else {
                return false
            }
            return self.isTarget(viewController, with: context)
        }

        return try iterator.firstViewController(where: predicate) as? ViewController
    }

}
