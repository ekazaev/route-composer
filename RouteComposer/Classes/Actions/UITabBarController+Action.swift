//
// Created by Eugene Kazaev on 2018-09-18.
//

import Foundation
import UIKit

/// Actions for `UITabBarController`
extension ContainerViewController where Self: UITabBarController {

    /// Adds a `UIViewController` to a `UITabBarController`
    ///
    ///   - tabIndex: index of a tab.
    ///   - replacing: should be set to `true` if an existing view controller should be replaced.
    ///     If condition has not been passed, a view controller
    ///   will be added after the latest one.
    public static func addTab(at tabIndex: Int, replacing: Bool = false) -> TabBarControllerActions.AddTabAction<Self> {
        return TabBarControllerActions.AddTabAction(at: tabIndex, replacing: replacing)
    }

    /// Adds a `UIViewController` to a `UITabBarController`
    ///
    ///   - tabIndex: index of a tab.
    ///     If condition has not been passed, a view controller
    ///   will be added after the latest one.
    public static func addTab(at tabIndex: Int? = nil) -> TabBarControllerActions.AddTabAction<Self> {
        return TabBarControllerActions.AddTabAction(at: tabIndex)
    }

}

/// Actions for `UITabBarController`
public struct TabBarControllerActions {

    /// Integrates a `UIViewController` in to a `UITabBarController`
    public struct AddTabAction<ViewController: UITabBarController>: ContainerAction {

        let tabIndex: Int?

        let replacing: Bool

        /// Constructor
        ///
        /// - Parameters:
        ///   - tabIndex: index of the tab after which one a view controller should be added.
        ///   - replacing: instead of adding a view controller after the tabIndex - replace the one at that index.
        init(at tabIndex: Int, replacing: Bool = false) {
            self.tabIndex = tabIndex
            self.replacing = replacing
        }

        /// Constructor
        ///
        ///   - tabIndex: index of the tab after which one a view controller should be added.
        ///     If has not been passed - a view controller
        ///   will be added after the latest one.
        init(at tabIndex: Int? = nil) {
            self.tabIndex = tabIndex
            self.replacing = false
        }

        public func perform(embedding viewController: UIViewController,
                            in childViewControllers: inout [UIViewController]) {
            processViewController(viewController: viewController, childViewControllers: &childViewControllers)
        }

        public func perform(with viewController: UIViewController,
                            on tabBarController: ViewController,
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
