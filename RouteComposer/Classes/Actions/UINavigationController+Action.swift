//
// RouteComposer
// UINavigationController+Action.swift
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

// MARK: Actions for UINavigationController

public extension ContainerViewController where Self: UINavigationController {

    // MARK: Steps

    /// Replaces all the child view controllers in the `UINavigationController`'s children stack
    static func pushAsRoot() -> NavigationControllerActions.PushAsRootAction<Self> {
        NavigationControllerActions.PushAsRootAction()
    }

    /// Pushes a child view controller into the `UINavigationController`'s children stack
    static func push() -> NavigationControllerActions.PushAction<Self> {
        NavigationControllerActions.PushAction()
    }

    /// Pushes a child view controller, replacing the existing, into the `UINavigationController`'s children stack
    static func pushReplacingLast() -> NavigationControllerActions.PushReplacingLastAction<Self> {
        NavigationControllerActions.PushReplacingLastAction()
    }

}

/// Actions for `UINavigationController`
public enum NavigationControllerActions {

    // MARK: Internal entities

    /// Pushes a view controller into `UINavigationController`'s child stack
    public struct PushAction<ViewController: UINavigationController>: ContainerAction {

        // MARK: Methods

        /// Constructor
        init() {}

        public func perform(with viewController: UIViewController,
                            on navigationController: ViewController,
                            animated: Bool,
                            completion: @escaping (_: RoutingResult) -> Void) {
            navigationController.pushViewController(viewController, animated: animated)
            if let transitionCoordinator = navigationController.transitionCoordinator, animated {
                transitionCoordinator.animate(alongsideTransition: nil) { _ in
                    completion(.success)
                }
            } else {
                completion(.success)
            }
        }

    }

    /// Replaces all the child view controllers in the `UINavigationController`'s child stack
    public struct PushAsRootAction<ViewController: UINavigationController>: ContainerAction {

        // MARK: Methods

        /// Constructor
        init() {}

        public func perform(embedding viewController: UIViewController,
                            in childViewControllers: inout [UIViewController]) {
            childViewControllers.removeAll()
            childViewControllers.append(viewController)
        }

        public func perform(with viewController: UIViewController,
                            on navigationController: ViewController,
                            animated: Bool,
                            completion: @escaping (_: RoutingResult) -> Void) {
            navigationController.setViewControllers([viewController], animated: animated)
            if let transitionCoordinator = navigationController.transitionCoordinator, animated {
                transitionCoordinator.animate(alongsideTransition: nil) { _ in
                    completion(.success)
                }
            } else {
                completion(.success)
            }
        }

    }

    /// Pushes a view controller into the `UINavigationController`'s child stack replacing the last one
    public struct PushReplacingLastAction<ViewController: UINavigationController>: ContainerAction {

        // MARK: Methods

        /// Constructor
        init() {}

        public func perform(embedding viewController: UIViewController,
                            in childViewControllers: inout [UIViewController]) {
            if !childViewControllers.isEmpty {
                childViewControllers.removeLast()
            }
            childViewControllers.append(viewController)
        }

        public func perform(with viewController: UIViewController,
                            on navigationController: ViewController,
                            animated: Bool,
                            completion: @escaping (_: RoutingResult) -> Void) {
            var viewControllers = navigationController.viewControllers
            perform(embedding: viewController, in: &viewControllers)
            navigationController.setViewControllers(viewControllers, animated: animated)
            if let transitionCoordinator = navigationController.transitionCoordinator, animated {
                transitionCoordinator.animate(alongsideTransition: nil) { _ in
                    completion(.success)
                }
            } else {
                completion(.success)
            }
        }

    }

}
