//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit

/// - The `UINavigationController` extension to support the `ContainerViewController` protocol
extension UINavigationController: ContainerViewController {

    public var containingViewControllers: [UIViewController] {
        return viewControllers
    }

    public var visibleViewControllers: [UIViewController] {
        guard let visibleViewController = visibleViewController else {
            return []
        }
        return [visibleViewController]
    }

    public func makeVisible(_ viewController: UIViewController, animated: Bool) {
        guard visibleViewController != viewController else {
            return
        }
        for containingViewController in containingViewControllers where containingViewController == viewController {
            self.popToViewController(containingViewController, animated: animated)
            return
        }
    }

}

/// - The `UINavigationController` extension to support the `RoutingInterceptable` protocol
extension UINavigationController: RoutingInterceptable {

    public var canBeDismissed: Bool {
        return containingViewControllers.canBeDismissed
    }

}

// Just an `Action`s holder
extension UINavigationController {

    /// Pushes a view controller in to `UINavigationController`'s child stack
    public struct PushAction<SC: Container>: ContainerAction where SC.ViewController: UINavigationController {

        /// Constructor
        init() {
        }

        public func perform(with viewController: UIViewController,
                            on navigationController: SC.ViewController,
                            animated: Bool,
                            completion: @escaping(_: ActionResult) -> Void) {
            navigationController.pushViewController(viewController, animated: animated)
            return completion(.continueRouting)
        }

    }

    /// Replaces all the child view controllers in the `UINavigationController`'s child stack
    public struct PushAsRootAction<SC: Container>: ContainerAction where SC.ViewController: UINavigationController {

        /// Constructor
        init() {
        }

        public func perform(embedding viewController: UIViewController,
                            in childViewControllers: inout [UIViewController]) {
            childViewControllers.removeAll()
            childViewControllers.append(viewController)
        }

        public func perform(with viewController: UIViewController,
                            on navigationController: SC.ViewController,
                            animated: Bool,
                            completion: @escaping(_: ActionResult) -> Void) {
            navigationController.setViewControllers([viewController], animated: animated)
            return completion(.continueRouting)
        }

    }

    /// Pushes a view controller into the `UINavigationController`'s child stack replacing the last one
    public struct PushReplacingLastAction<SC: Container>: ContainerAction where SC.ViewController: UINavigationController {

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
                            on navigationController: SC.ViewController,
                            animated: Bool,
                            completion: @escaping(_: ActionResult) -> Void) {
            var viewControllers = navigationController.viewControllers
            perform(embedding: viewController, in: &viewControllers)
            navigationController.setViewControllers(viewControllers, animated: animated)
            return completion(.continueRouting)
        }

    }

}
