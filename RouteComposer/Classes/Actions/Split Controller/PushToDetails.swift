//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit

/// Presents detail view controller in UISplitViewController
public extension SplitControllerFactory {

    /// Presents detail view controller in UISplitViewController
    public class PushToDetails: SplitControllerDetailAction {

        /// Constructor
        public init() {
        }

        public func perform(viewController: UIViewController, on existingController: UIViewController, animated: Bool, completion: @escaping (_: ActionResult) -> Void) {
            guard let splitViewController = existingController as? UISplitViewController ?? existingController.splitViewController,
                  splitViewController.viewControllers.count > 0 else {
                completion(.failure("Could not find UISplitViewController in \(existingController) to present details view controller \(viewController)."))
                return
            }

            splitViewController.showDetailViewController(viewController, sender: nil)
            completion(.continueRouting)
        }
    }

}
