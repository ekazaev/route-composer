//
// Created by Eugene Kazaev on 23/01/2018.
//

import Foundation
import UIKit

/// Presents a master view controller in the `UISplitViewController`
public extension SplitControllerFactory {

    /// Presents a master view controller in the `UISplitViewController`
    public struct PushToMaster: SplitControllerAction {

        /// Constructor
        public init() {
        }

        public func perform(embedding viewController: UIViewController, in childViewControllers: inout [UIViewController]) {
            if !childViewControllers.isEmpty {
                childViewControllers.insert(viewController, at: 0)
            } else {
                childViewControllers.append(viewController)
            }
        }

        public func perform(with viewController: UIViewController,
                            on existingController: UIViewController,
                            animated: Bool,
                            completion: @escaping (_: ActionResult) -> Void) {
            guard let splitViewController = existingController as? UISplitViewController ?? existingController.splitViewController,
                  !splitViewController.viewControllers.isEmpty else {
                completion(.failure("Could not find UISplitViewController in \(existingController) to present master view controller \(viewController)."))
                return
            }

            splitViewController.viewControllers[0] = viewController
            completion(.continueRouting)
        }

    }

}
