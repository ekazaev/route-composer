//
// Created by Eugene Kazaev on 2018-09-18.
//

import Foundation
import UIKit

/// Actions for `UINavigationController`
public extension ContainerViewController where Self: UINavigationController {

    /// Replaces all the child view controllers in the `UINavigationController`'s children stack
    static func pushAsRoot() -> NavigationControllerActions.PushAsRootAction<Self> {
        return NavigationControllerActions.PushAsRootAction()
    }

    /// Pushes a child view controller into the `UINavigationController`'s children stack
    static func push() -> NavigationControllerActions.PushAction<Self> {
        return NavigationControllerActions.PushAction()
    }

    /// Pushes a child view controller, replacing the existing, into the `UINavigationController`'s children stack
    static func pushReplacingLast() -> NavigationControllerActions.PushReplacingLastAction<Self> {
        return NavigationControllerActions.PushReplacingLastAction()
    }

}

/// Actions for `UINavigationController`
public struct NavigationControllerActions {

    /// Pushes a view controller into `UINavigationController`'s child stack
    public struct PushAction<ViewController: UINavigationController>: ContainerAction {

        /// Constructor
        init() {
        }

        public func perform(with viewController: UIViewController,
                            on navigationController: ViewController,
                            animated: Bool,
                            completion: @escaping(_: ActionResult) -> Void) {
            if animated {
                navigationController.pushViewController(viewController, animated: true)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(350)) {
                    completion(.continueRouting)
                }
            } else {
                navigationController.pushViewController(viewController, animated: false)
                completion(.continueRouting)
            }
        }

    }

    /// Replaces all the child view controllers in the `UINavigationController`'s child stack
    public struct PushAsRootAction<ViewController: UINavigationController>: ContainerAction {

        /// Constructor
        init() {
        }

        public func perform(embedding viewController: UIViewController,
                            in childViewControllers: inout [UIViewController]) {
            childViewControllers.removeAll()
            childViewControllers.append(viewController)
        }

        public func perform(with viewController: UIViewController,
                            on navigationController: ViewController,
                            animated: Bool,
                            completion: @escaping(_: ActionResult) -> Void) {
            navigationController.setViewControllers([viewController], animated: animated)
            return completion(.continueRouting)
        }

    }

    /// Pushes a view controller into the `UINavigationController`'s child stack replacing the last one
    public struct PushReplacingLastAction<ViewController: UINavigationController>: ContainerAction {

        /// Constructor
        init() {
        }

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
                            completion: @escaping(_: ActionResult) -> Void) {
            var viewControllers = navigationController.viewControllers
            perform(embedding: viewController, in: &viewControllers)
            navigationController.setViewControllers(viewControllers, animated: animated)
            return completion(.continueRouting)
        }

    }

}
