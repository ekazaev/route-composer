//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import UIKit

/// Pushes a view controller into the `UINavigationController`'s child stack replacing the last one
public extension NavigationControllerFactory {

    /// Pushes a view controller into the `UINavigationController`'s child stack replacing the last one
    public struct PushReplacingLast: ContainerAction {

        public typealias SupportedContainer = NavigationControllerFactory

        /// Constructor
        public init() {
        }

        public func perform(embedding viewController: UIViewController,
                            in childViewControllers: inout [UIViewController]) {
            if !childViewControllers.isEmpty {
                childViewControllers.removeLast()
            }
            childViewControllers.append(viewController)
        }

        public func perform(with viewController: UIViewController,
                            on navigationController: UINavigationController,
                            animated: Bool,
                            completion: @escaping(_: ActionResult) -> Void) {
            var viewControllers = navigationController.viewControllers
            perform(embedding: viewController, in: &viewControllers)
            navigationController.setViewControllers(viewControllers, animated: animated)
            return completion(.continueRouting)
        }

    }

}
