//
// Created by Eugene Kazaev on 07/02/2018.
//

import Foundation
import UIKit

class PushAsRootAction: NavigationControllerFactoryAction {

    public init() {
    }

    public func performMerged(viewController: UIViewController, containerViewControllers: inout [UIViewController], logger: Logger?) {
        containerViewControllers.removeAll()
        containerViewControllers.append(viewController)
    }

    public func perform(viewController: UIViewController, on existingController: UIViewController, animated: Bool, logger: Logger?, completion: @escaping(_: UIViewController) -> Void) {
        guard let nv = existingController as? UINavigationController ?? existingController.navigationController else {
            logger?.log(.error("Could not find UINavigationController in \(existingController) to present view controller \(viewController)."))
            return completion(existingController)
        }

        nv.setViewControllers([viewController], animated: animated)
        return completion(viewController)
    }

}
