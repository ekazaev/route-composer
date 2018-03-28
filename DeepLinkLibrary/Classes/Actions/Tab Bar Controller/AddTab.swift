//
// Created by Eugene Kazaev on 07/02/2018.
//

import Foundation
import UIKit

public extension TabBarControllerFactory {

    /// Integrates UIViewController in to a UITabBarController
    public class AddTab: TabBarControllerAction {

        let tabIndex: Int?

        let replacing: Bool

        /// Constructor
        ///
        /// - Parameters:
        ///   - tabIndex: index of the tab after which one view controller should be added.
        ///   - replacing: instead of adding view controller after tabIndex - replace one at that index.
        public init(at tabIndex: Int, replacing: Bool = false) {
            self.tabIndex = tabIndex
            self.replacing = replacing
        }

        /// Constructor
        ///
        ///   - tabIndex: index of the tab after which one view controller should be added. If not passes - view controller
        ///   will be added after the latest one.
        public init(at tabIndex: Int? = nil) {
            self.tabIndex = tabIndex
            self.replacing = false
        }

        public func perform(embedding viewController: UIViewController, in containerViewControllers: inout [UIViewController]) {
            processViewController(viewController: viewController, containerViewControllers: &containerViewControllers)
        }

        public func perform(viewController: UIViewController, on existingController: UIViewController, animated: Bool, completion: @escaping(_: ActionResult) -> Void) {
            guard let tabBarController = existingController as? UITabBarController ?? existingController.tabBarController else {
                return completion(.failure("Could not find UITabBarController in \(existingController) to present view controller \(viewController)."))
            }

            var tabViewControllers = tabBarController.viewControllers ?? []
            processViewController(viewController: viewController, containerViewControllers: &tabViewControllers)
            tabBarController.setViewControllers(tabViewControllers, animated: animated)

            return completion(.continueRouting)
        }

        private func processViewController(viewController: UIViewController, containerViewControllers: inout [UIViewController]){
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

}