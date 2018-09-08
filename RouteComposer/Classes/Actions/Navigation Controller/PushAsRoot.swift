//
// Created by Eugene Kazaev on 07/02/2018.
//

import Foundation
import UIKit

/// Replaces all the child view controllers in the `UINavigationController`'s child stack
public extension NavigationControllerFactory {

    /// Replaces all the child view controllers in the `UINavigationController`'s child stack
    public struct PushAsRoot: ContainerAction {

        public typealias SupportedContainer = NavigationControllerFactory

        /// Constructor
        public init() {
        }

        public func perform(embedding viewController: UIViewController,
                            in childViewControllers: inout [UIViewController]) {
            childViewControllers.removeAll()
            childViewControllers.append(viewController)
        }

        public func perform(with viewController: UIViewController,
                            on navigationController: UINavigationController,
                            animated: Bool,
                            completion: @escaping(_: ActionResult) -> Void) {
            navigationController.setViewControllers([viewController], animated: animated)
            return completion(.continueRouting)
        }

    }

}
