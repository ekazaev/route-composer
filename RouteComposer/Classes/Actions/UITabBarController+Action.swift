//
// RouteComposer
// UITabBarController+Action.swift
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

// MARK: Actions for UITabBarController

public extension ContainerViewController where Self: UITabBarController {

    // MARK: Steps

    /// Adds a `UIViewController` to a `UITabBarController`
    ///
    ///   - tabIndex: index of a tab.
    ///   - replacing: should be set to `true` if an existing view controller should be replaced.
    ///     If condition has not been passed, a view controller
    ///   will be added after the latest one.
    static func add(at tabIndex: Int, replacing: Bool = false) -> TabBarControllerActions.AddTabAction<Self> {
        TabBarControllerActions.AddTabAction(at: tabIndex, replacing: replacing)
    }

    /// Adds a `UIViewController` to a `UITabBarController`
    ///
    ///   - tabIndex: index of a tab.
    ///     If condition has not been passed, a view controller
    ///   will be added after the latest one.
    static func add(at tabIndex: Int? = nil) -> TabBarControllerActions.AddTabAction<Self> {
        TabBarControllerActions.AddTabAction(at: tabIndex)
    }

}

/// Actions for `UITabBarController`
public enum TabBarControllerActions {

    // MARK: Internal entities

    /// Integrates a `UIViewController` in to a `UITabBarController`
    public struct AddTabAction<ViewController: UITabBarController>: ContainerAction {

        // MARK: Properties

        /// The index of the tab after which one a view controller should be added.
        public let tabIndex: Int?

        /// The flag that tab should be replaced instead.
        public let replacing: Bool

        // MARK: Methods

        /// Constructor
        ///
        /// - Parameters:
        ///   - tabIndex: index of the tab after which one a view controller should be added.
        ///   - replacing: instead of adding a view controller after the tabIndex - replace the one at that index.
        init(at tabIndex: Int, replacing: Bool = false) {
            self.tabIndex = tabIndex
            self.replacing = replacing
        }

        /// Constructor
        ///
        ///   - tabIndex: index of the tab after which one a view controller should be added.
        ///     If has not been passed - a view controller
        ///   will be added after the latest one.
        init(at tabIndex: Int? = nil) {
            self.tabIndex = tabIndex
            self.replacing = false
        }

        public func perform(embedding viewController: UIViewController,
                            in childViewControllers: inout [UIViewController]) {
            setup(viewController: viewController, at: &childViewControllers, tabIndex: tabIndex)
        }

        public func perform(with viewController: UIViewController,
                            on tabBarController: ViewController,
                            animated: Bool,
                            completion: @escaping (_: RoutingResult) -> Void) {
            var tabViewControllers = tabBarController.viewControllers ?? []
            setup(viewController: viewController, at: &tabViewControllers, tabIndex: tabIndex)
            tabBarController.setViewControllers(tabViewControllers, animated: animated)

            completion(.success)
        }

        private func setup(viewController: UIViewController,
                           at childViewControllers: inout [UIViewController], tabIndex: Int?) {
            if let tabIndex, tabIndex < childViewControllers.count {
                if replacing {
                    childViewControllers[tabIndex] = viewController
                } else {
                    childViewControllers.insert(viewController, at: tabIndex)
                }
            } else {
                childViewControllers.append(viewController)
            }
        }

    }

}
