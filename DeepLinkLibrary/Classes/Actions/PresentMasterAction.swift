//
// Created by Eugene Kazaev on 23/01/2018.
//

import Foundation
import UIKit

// TODO: Undone
public class PresentMasterAction: SplitViewControllerMasterAction {

    public init() {

    }

    public func applyMerged(viewController: UIViewController, containerViewControllers: inout [UIViewController], logger: Logger?) {
        containerViewControllers.append(viewController)
    }

    public func apply(viewController: UIViewController, on existingController: UIViewController, animated: Bool, logger: Logger?, completion: @escaping (_: UIViewController) -> Void) {
        guard let splitViewController = existingController as? UISplitViewController ?? existingController.splitViewController,
              splitViewController.viewControllers.count > 0 else {
            logger?.log(.error("Could not find UISplitViewController in \(existingController) to present master view controller \(viewController)."))
            completion(existingController)
            return
        }

        splitViewController.viewControllers[0] = viewController
        completion(viewController)
    }
}