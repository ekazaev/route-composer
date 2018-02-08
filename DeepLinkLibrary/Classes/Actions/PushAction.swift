//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

public class PushAction: NavigationControllerFactoryAction {

    public init() {
    }
    
    public func performMerged(viewController: UIViewController, containerViewControllers: inout [UIViewController], logger: Logger?) {
        containerViewControllers.append(viewController)
    }

    public func perform(viewController: UIViewController, on existingController: UIViewController, animated: Bool, logger: Logger?, completion: @escaping(_: ActionResult) -> Void) {
        guard let nv = existingController as? UINavigationController ?? existingController.navigationController else {
            logger?.log(.error("Could not find UINavigationController in \(existingController) to present view controller \(viewController)."))
            return completion(.failure)
        }

        nv.pushViewController(viewController, animated: animated)
        return completion(.continueRouting)
    }

}
