//
// Created by Eugene Kazaev on 07/02/2018.
//

import Foundation
import UIKit

/// Replaces all child view controllers in UINavigationController's stack with a new one.
public extension NavigationControllerFactory {

    public class PushAsRoot: NavigationControllerAction {

        public init() {
        }

        public func perform(embedding viewController: UIViewController, in containerViewControllers: inout [UIViewController]) {
            containerViewControllers.removeAll()
            containerViewControllers.append(viewController)
        }

        public func perform(viewController: UIViewController, on existingController: UIViewController, animated: Bool, completion: @escaping(_: ActionResult) -> Void) {
            guard let navigationController = existingController as? UINavigationController ?? existingController.navigationController else {
                return completion(.failure("Could not find UINavigationController in \(existingController) to present view controller \(viewController)."))
            }

            navigationController.setViewControllers([viewController], animated: animated)
            return completion(.continueRouting)
        }

    }

}