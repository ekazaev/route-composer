//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

public class PresentDetailsAction: SplitViewControllerDetailAction {

    public init() {
    }

    public func perform(viewController: UIViewController, on existingController: UIViewController, animated: Bool, logger: Logger?, completion: @escaping (_: ActionResult) -> Void) {
        guard let splitViewController = existingController as? UISplitViewController ?? existingController.splitViewController,
              splitViewController.viewControllers.count > 0 else {
            logger?.log(.error("Could not find UISplitViewController in \(existingController) to present details view controller \(viewController)."))
            completion(.failure)
            return
        }

        splitViewController.showDetailViewController(viewController, sender: nil)
        completion(.continueRouting)
    }
}
