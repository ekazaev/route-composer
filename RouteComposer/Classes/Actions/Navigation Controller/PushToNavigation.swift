//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import UIKit

/// Pushes a view controller in to `UINavigationController`'s child stack
public extension NavigationControllerFactory {

    /// Pushes a view controller in to `UINavigationController`'s child stack
    public struct PushToNavigation: ContainerAction {

        public typealias SupportedContainer = NavigationControllerFactory

        /// Constructor
        public init() {
        }

        public func perform(with viewController: UIViewController,
                            on navigationController: UINavigationController,
                            animated: Bool,
                            completion: @escaping(_: ActionResult) -> Void) {
            navigationController.pushViewController(viewController, animated: animated)
            return completion(.continueRouting)
        }

    }

}
