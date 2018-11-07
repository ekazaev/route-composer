//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit

/// `StackIteratingFinder` iterates through the view controllers stack
/// following the search options provided. It simplifies the creation of the finders for a hosting app.
public protocol StackIteratingFinder: Finder {

    /// Type of the `UIViewController` that `Finder` can find
    associatedtype ViewController = ViewController

    /// Type of context `Context` instance that `Finder` can deal with
    associatedtype Context = Context

    /// `StackIterator` to be used by `StackIteratingFinder`
    var iterator: StackIterator { get }

    /// The method to be implemented by the `StackIteratingFinder` instance
    ///
    /// - Parameters:
    ///   - viewController: A view controller in the current view controller stack
    ///   - context: The `Context` instance provided to the `Router`.
    /// - Returns: true if this view controller is the one that `Finder` is looking for, false otherwise.
    func isTarget(_ viewController: ViewController, with context: Context) -> Bool

}

public extension StackIteratingFinder {

    func findViewController(with context: Context) -> ViewController? {
        let comparator: (UIViewController) -> Bool = {
            guard let viewController = $0 as? ViewController else {
                return false
            }
            return self.isTarget(viewController, with: context)
        }

        return iterator.findViewController(using: comparator) as? ViewController
    }

}
