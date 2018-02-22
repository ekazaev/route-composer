//
// Created by Eugene Kazaev on 07/02/2018.
//

import Foundation
import UIKit

class PushAsRootAction: NavigationControllerFactoryAction {

    public init() {
    }

    @discardableResult
    public func performMerged(viewController: UIViewController, containerViewControllers: inout [UIViewController]) -> ActionResult {
        containerViewControllers.removeAll()
        containerViewControllers.append(viewController)
        return .continueRouting
    }

    public func perform(viewController: UIViewController, on existingController: UIViewController, animated: Bool, completion: @escaping(_: ActionResult) -> Void) {
        guard let nv = existingController as? UINavigationController ?? existingController.navigationController else {
            return completion(.failure("Could not find UINavigationController in \(existingController) to present view controller \(viewController)."))
        }

        nv.setViewControllers([viewController], animated: animated)
        return completion(.continueRouting)
    }

}
