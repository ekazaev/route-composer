//
// RouteComposer
// UISplitViewController+Action.swift
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

// MARK: Actions for UISplitViewController

public extension ContainerViewController where Self: UISplitViewController {

    // MARK: Steps

    /// Presents a view controller as a master in the `UISplitViewController`
    static func setAsMaster() -> SplitViewControllerActions.SetAsMasterAction<Self> {
        SplitViewControllerActions.SetAsMasterAction()
    }

    /// Presents a view controller as a detail in the `UISplitViewController`, *replacing* the previous detail.
    static func pushToDetails() -> SplitViewControllerActions.PushToDetailsAction<Self> {
        SplitViewControllerActions.PushToDetailsAction()
    }

    /// Pushes a view controller *onto* the detail stack in the `UISplitViewController`. Requires the root detail view
    /// controller to be the `UINavigationController`
    static func pushOnToDetails() -> RouteComposer.SplitViewControllerActions.PushOnToDetailsAction<Self> {
        SplitViewControllerActions.PushOnToDetailsAction()
    }

}

/// Actions for `UISplitViewController`
public enum SplitViewControllerActions {

    // MARK: Internal entities

    /// Presents a master view controller in the `UISplitViewController`
    public struct SetAsMasterAction<ViewController: UISplitViewController>: ContainerAction {

        // MARK: Methods

        /// Constructor
        init() {}

        public func perform(embedding viewController: UIViewController, in childViewControllers: inout [UIViewController]) throws {
            integrate(viewController: viewController, in: &childViewControllers)
        }

        public func perform(with viewController: UIViewController,
                            on splitViewController: ViewController,
                            animated: Bool,
                            completion: @escaping (_: RoutingResult) -> Void) {
            integrate(viewController: viewController, in: &splitViewController.viewControllers)
            completion(.success)
        }

        private func integrate(viewController: UIViewController, in childViewControllers: inout [UIViewController]) {
            if childViewControllers.isEmpty {
                childViewControllers.append(viewController)
            } else {
                childViewControllers[0] = viewController
            }
        }

    }

    /// Presents a detail view controller in the `UISplitViewController`, *replacing* the previous detail.
    public struct PushToDetailsAction<ViewController: UISplitViewController>: ContainerAction {

        // MARK: Methods

        /// Constructor
        init() {}

        public func perform(embedding viewController: UIViewController, in childViewControllers: inout [UIViewController]) throws {
            guard !childViewControllers.isEmpty else {
                throw RoutingError.compositionFailed(.init("Master view controller is not set in " +
                        "UISplitViewController to present a detail view controller \(viewController)."))
            }
            childViewControllers.append(viewController)
        }

        public func perform(with viewController: UIViewController,
                            on splitViewController: ViewController,
                            animated: Bool,
                            completion: @escaping (_: RoutingResult) -> Void) {
            guard !splitViewController.viewControllers.isEmpty else {
                completion(.failure(RoutingError.compositionFailed(.init("Master view controller is not set in " +
                        "\(splitViewController) to present a detail view controller \(viewController)."))))
                return
            }

            splitViewController.showDetailViewController(viewController, sender: nil)
            completion(.success)
        }
    }

    /// Pushes a view controller *onto* the detail stack in the `UISplitViewController`, where the detail is a `UINavigationController`
    public struct PushOnToDetailsAction<ViewController: UISplitViewController>: ContainerAction {

        // MARK: Methods

        /// Constructor
        init() {}

        public func perform(embedding viewController: UIViewController, in childViewControllers: inout [UIViewController]) throws {
            guard !childViewControllers.isEmpty else {
                throw RoutingError.compositionFailed(.init("Master view controller is not set in " +
                        "UISplitViewController to push on a detail view controller \(viewController)."))
            }
            if childViewControllers.count > 1,
               let navigationController = childViewControllers.last as? UINavigationController {
                guard !(viewController is UINavigationController) else {
                    throw RoutingError.compositionFailed(.init("The navigation controller is already set as a detail view controller root."))
                }
                navigationController.viewControllers = Array([navigationController.viewControllers, [viewController]].joined())
            } else {
                guard viewController is UINavigationController else {
                    throw RoutingError.compositionFailed(.init("Action requires a `UINavigationController` to be set as a detail view controller root. " +
                            "Got \(viewController) instead."))
                }
                childViewControllers.append(viewController)
            }
        }

        public func perform(with viewController: UIViewController,
                            on splitController: ViewController,
                            animated: Bool,
                            completion: @escaping (_: RoutingResult) -> Void) {
            guard !splitController.viewControllers.isEmpty else {
                completion(.failure(RoutingError.compositionFailed(.init("Master view controller is not set in " +
                        "\(splitController) to push on a detail view controller \(viewController)."))))
                return
            }

            guard let navigationController = (splitController.viewControllers.last as? UINavigationController) else {
                completion(.failure(RoutingError.compositionFailed(.init("Detail navigation controller is not set in " +
                        "\(splitController) to push on a detail view controller \(viewController)."))))
                return
            }
            if navigationController.viewControllers.isEmpty {
                navigationController.setViewControllers([viewController], animated: animated)
            } else {
                navigationController.pushViewController(viewController, animated: animated)
            }
            completion(.success)
        }
    }

}
