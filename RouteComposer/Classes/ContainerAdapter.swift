//
// RouteComposer
// ContainerAdapter.swift
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

/// Provides universal properties and methods of the `ContainerViewController` instance.
///
/// `ContainerViewController`s are different from the simple ones in that they can contain child view controllers which
/// are also containers or simple ones. These view controllers are available out of the box: `UINavigationController`,
/// `UITabBarController` and so on, but there can be custom ones created as well.
///
/// All the container view controller have the following properties:
///  1. The list of all the view controllers that they contain.
///  2. One or more view controllers are currently visible.
///  3. They can make one of these view controllers visible.
///  4. They can replace all of their contained view controllers.
public protocol ContainerAdapter {

    // MARK: Properties to implement

    /// All `UIViewController` instances that adapting `ContainerViewController` currently has in the stack
    var containedViewControllers: [UIViewController] { get }

    /// The `UIViewController` instances out of the `containedViewControllers` that are currently visible on the screen
    /// The `visibleViewControllers` are the subset of the `containedViewControllers`.
    var visibleViewControllers: [UIViewController] { get }

    // MARK: Methods to implement

    /// Each container view controller adapter should implement this method for the `Router` to know how to make
    /// its particular child view controller visible.
    ///
    /// NB: `completion` block must be called.
    ///
    /// - Parameters:
    ///   - viewController: The `UIViewController` to make active (visible).
    ///   - animated: If `ContainerViewController` is able to do so - make container active animated or not.
    func makeVisible(_ viewController: UIViewController, animated: Bool, completion: @escaping (_: RoutingResult) -> Void)

    /// Each container view controller adapter should implement this method for the `Router` to know how to replace all the
    /// view controllers in this particular container view controller.
    ///
    /// NB: `completion` block must be called.
    ///
    /// - Parameters:
    ///   - containedViewControllers: A `UIViewController` instances to replace.
    ///   - animated: If `ContainerViewController` is able to do so - replace contained view controllers animated or not.
    func setContainedViewControllers(_ containedViewControllers: [UIViewController], animated: Bool, completion: @escaping (_: RoutingResult) -> Void)

}

// MARK: Helper methods

public extension ContainerAdapter {

    /// Checks if the provided view controller is present amongst the contained view controllers.
    ///
    /// - Parameter viewController: `UIViewController` instance
    /// - Returns: `true` if present, `false` otherwise.
    func contains(_ viewController: UIViewController) -> Bool {
        containedViewControllers.contains(viewController)
    }

    /// Checks if the provided view controller is present amongst the visible view controllers.
    ///
    /// - Parameter viewController: `UIViewController` instance
    /// - Returns: `true` if present, `false` otherwise.
    func isVisible(_ viewController: UIViewController) -> Bool {
        visibleViewControllers.contains(viewController)
    }

}
