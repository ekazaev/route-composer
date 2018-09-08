//
// Created by Eugene Kazaev on 07/02/2018.
//

import Foundation
import UIKit

/// Integrates a `UIViewController` in to a `UITabBarController`
public extension TabBarControllerFactory {

    /// Integrates a `UIViewController` in to a `UITabBarController`
    public struct AddTab: ContainerAction {

        public typealias SupportedContainer = TabBarControllerFactory

        let tabIndex: Int?

        let replacing: Bool

        /// Constructor
        ///
        /// - Parameters:
        ///   - tabIndex: index of the tab after which one a view controller should be added.
        ///   - replacing: instead of adding a view controller after the tabIndex - replace the one at that index.
        public init(at tabIndex: Int, replacing: Bool = false) {
            self.tabIndex = tabIndex
            self.replacing = replacing
        }

        /// Constructor
        ///
        ///   - tabIndex: index of the tab after which one a view controller should be added.
        ///     If has not been passed - a view controller
        ///   will be added after the latest one.
        public init(at tabIndex: Int? = nil) {
            self.tabIndex = tabIndex
            self.replacing = false
        }

        public func perform(embedding viewController: UIViewController,
                            in childViewControllers: inout [UIViewController]) {
            processViewController(viewController: viewController, childViewControllers: &childViewControllers)
        }

        public func perform(with viewController: UIViewController,
                            on tabBarController: UITabBarController,
                            animated: Bool,
                            completion: @escaping(_: ActionResult) -> Void) {
            var tabViewControllers = tabBarController.viewControllers ?? []
            processViewController(viewController: viewController, childViewControllers: &tabViewControllers)
            tabBarController.setViewControllers(tabViewControllers, animated: animated)

            return completion(.continueRouting)
        }

        private func processViewController(viewController: UIViewController,
                                           childViewControllers: inout [UIViewController]) {
            if let tabIndex = tabIndex, tabIndex < childViewControllers.count {
                if replacing {
                    childViewControllers[tabIndex] = viewController
                } else {
                    childViewControllers.insert(viewController, at: tabIndex)
                }
            } else {
                childViewControllers.append(viewController)
            }
        }

    }

}
