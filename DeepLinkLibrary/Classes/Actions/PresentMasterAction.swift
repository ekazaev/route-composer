//
// Created by Eugene Kazaev on 23/01/2018.
//

import Foundation
import UIKit

// TODO: Undone
public class PresentMasterAction: SplitViewControllerMasterAction {

    public init() {
    }

    public func performMerged(viewController: UIViewController, containerViewControllers: inout [UIViewController]) -> ActionResult {
        containerViewControllers.append(viewController)
        return .continueRouting
    }

    public func perform(viewController: UIViewController, on existingController: UIViewController, animated: Bool, completion: @escaping (_: ActionResult) -> Void) {
        guard let splitViewController = existingController as? UISplitViewController ?? existingController.splitViewController,
              splitViewController.viewControllers.count > 0 else {
            completion(.failure("Could not find UISplitViewController in \(existingController) to present master view controller \(viewController)."))
            return
        }

        splitViewController.viewControllers[0] = viewController
        completion(.continueRouting)
    }
}