//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit

/// Simplifies creation of finders for a hosting app. If there is nothing special about finder, hosting app should
/// extend this `Finder` which will just iterations through view controllers stack following the search options provided
/// and just ask extending instances if this particular view controller is the one that `Router` looking for or no.
public protocol StackIteratingFinder: Finder {

    /// Type of `UIViewController` that `Finder` can find
    associatedtype ViewController = ViewController

    /// Type of `Context` instance that `Finder` can deal with
    associatedtype Context = Context

    /// `SearchOptions` to be used by `StackIteratingFinder`
    var options: SearchOptions { get }

    /// The method to be implemented by the StackIteratingFinder instance
    ///
    /// - Parameters:
    ///   - viewController: Some view controller in the current view controller stack
    ///   - context: The `Context` instance that was provided to the `Router`.
    /// - Returns: true if this view controller is the one that `Finder` is looking for, false otherwise.
    func isTarget(_ viewController: ViewController, with context: Context) -> Bool

}

public extension StackIteratingFinder {

    func findViewController(with context: Context) -> ViewController? {
        let comparator: (UIViewController) -> Bool = {
            guard let vc = $0 as? ViewController else {
                return false
            }
            return self.isTarget(vc, with: context)
        }

        guard let rootViewController = UIWindow.key?.topmostViewController,
              let viewController = UIViewController.findViewController(in: rootViewController, options: options, using: comparator) as? ViewController else {
            return nil
        }

        return viewController
    }

}
