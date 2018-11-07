//
// Created by Eugene Kazaev on 2018-11-07.
//

import Foundation
import UIKit

/// Default implementation of `StackIterator` protocol
public struct DefaultStackIterator: StackIterator {

    /// A starting point in the `UIViewController`s stack
    ///
    /// - topMost: Start from the topmost `UIViewController`
    /// - root: Start from the `UIWindow`s root `UIViewController`
    public enum StartingPoint {

        /// Start from the topmost `UIViewController`
        case topmost

        /// Start from the `UIWindow`s root `UIViewController`
        case root

    }

    /// `SearchOptions` to be used by `StackIteratingFinder`
    public let options: SearchOptions

    /// A starting point in the `UIViewController`s stack
    public let startingPoint: StartingPoint

    var startingViewController: UIViewController? {
        switch startingPoint {
        case .topmost:
            return UIWindow.key?.topmostViewController
        case .root:
            return UIWindow.key?.rootViewController
        }
    }

    /// Constructor
    public init(options: SearchOptions = .fullStack, startingPoint: StartingPoint = .topmost) {
        self.startingPoint = startingPoint
        self.options = options
    }

    /// Returns `UIViewController` instance if found
    ///
    /// - Parameter comparator: A block that contains `UIViewController` matching condition
    public func findViewController(using comparator: (UIViewController) -> Bool) -> UIViewController? {
        guard let rootViewController = startingViewController,
              let viewController = UIViewController.findViewController(in: rootViewController, options: options, using: comparator) else {
            return nil
        }

        return viewController
    }

}
