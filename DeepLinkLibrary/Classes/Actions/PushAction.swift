//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

public class PushAction: NavigationControllerFactoryAction {

    public init() {
    }

    public func performMerged(viewController: UIViewController, containerViewControllers: inout [UIViewController]){
        containerViewControllers.append(viewController)
    }

    public func perform(viewController: UIViewController, on existingController: UIViewController, animated: Bool, completion: @escaping(_: ActionResult) -> Void) {
        guard let navigationController = existingController as? UINavigationController ?? existingController.navigationController else {
            return completion(.failure("Could not find UINavigationController in \(existingController) to present view controller \(viewController)."))
        }

        navigationController.pushViewController(viewController, animated: animated)
        return completion(.continueRouting)
    }

}
