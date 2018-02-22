//
// Created by Eugene Kazaev on 07/02/2018.
//

import Foundation
import UIKit

public class AddTabAction: TabBarControllerFactoryAction {

    let tabIndex:Int?

    let replacing: Bool

    public init(at tabIndex:Int? = nil, replacing: Bool = false) {
        self.tabIndex = tabIndex
        self.replacing = replacing
    }

    public func performMerged(viewController: UIViewController, containerViewControllers: inout [UIViewController], logger: Logger?) {
        processViewController(viewController: viewController, containerViewControllers: &containerViewControllers, logger: logger)
    }

    public func perform(viewController: UIViewController, on existingController: UIViewController, animated: Bool, logger: Logger?, completion: @escaping(_: ActionResult) -> Void) {
        guard let tv = existingController as? UITabBarController ?? existingController.tabBarController else {
            logger?.log(.error("Could not find UITabBarController in \(existingController) to present view controller \(viewController)."))
            return completion(.failure)
        }

        var tabViewControllers = tv.viewControllers ?? []
        processViewController(viewController: viewController, containerViewControllers: &tabViewControllers, logger: logger)
        tv.setViewControllers(tabViewControllers, animated: animated)

        return completion(.continueRouting)
    }

    private func processViewController(viewController: UIViewController, containerViewControllers: inout [UIViewController], logger: Logger?) {
        if let tabIndex = tabIndex, tabIndex < containerViewControllers.count {
            if replacing {
                containerViewControllers[tabIndex] = viewController
            } else {
                containerViewControllers.insert(viewController, at: tabIndex)
            }
        } else {
            containerViewControllers.append(viewController)
        }
    }

}
