//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit

/// - The `UITabBarController` extension to support the `ContainerViewController` protocol
extension UITabBarController: ContainerViewController {

    public var containingViewControllers: [UIViewController] {
        guard let viewControllers = self.viewControllers else {
            return []
        }
        return viewControllers
    }

    public var visibleViewControllers: [UIViewController] {
        guard let visibleViewController = selectedViewController else {
            return []
        }
        return [visibleViewController]
    }

    public func makeVisible(_ viewController: UIViewController, animated: Bool) {
        guard selectedViewController != viewController else {
            return
        }
        for containingViewController in containingViewControllers where containingViewController == viewController {
            self.selectedViewController = containingViewController
            return
        }
    }

}

/// - The `UITabBarController` extension to support the `RoutingInterceptable` protocol
extension UITabBarController: RoutingInterceptable {

    public var canBeDismissed: Bool {
        return containingViewControllers.canBeDismissed
    }

}

// Just an `Action`s holder
extension UITabBarController {

    /// Integrates a `UIViewController` in to a `UITabBarController`
    public struct AddTabAction<SC: Container>: ContainerAction where SC.ViewController: UITabBarController {

        public typealias SupportedContainer = TabBarControllerFactory

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
