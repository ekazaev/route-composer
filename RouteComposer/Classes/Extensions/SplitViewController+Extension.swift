//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit

// - The `UISplitViewController` extension to support the `ContainerViewController` protocol
extension UISplitViewController: ContainerViewController {

    public var containingViewControllers: [UIViewController] {
        return viewControllers
    }

    public var visibleViewControllers: [UIViewController] {
        return containingViewControllers
    }

    public func makeVisible(_ viewController: UIViewController, animated: Bool) {
        guard viewController.navigationController?.navigationController?.visibleViewController != viewController else {
            return
        }
        for containingViewController in containingViewControllers where containingViewController == viewController {
            containingViewController.navigationController?.navigationController?.popToViewController(containingViewController, animated: animated)
            return
        }
    }

}

// - The `UISplitViewController` extension to support the `RoutingInterceptable` protocol
extension UISplitViewController: RoutingInterceptable {

    public var canBeDismissed: Bool {
        return containingViewControllers.canBeDismissed
    }

}

// Just an `Action`s holder
extension UISplitViewController {

    /// Presents a detail view controller in the `UISplitViewController`
    public struct PushToDetailsAction<SC: Container>: ContainerAction where SC.ViewController: UISplitViewController {

        /// Constructor
        init() {
        }

        public func perform(with viewController: UIViewController,
                            on splitViewController: SC.ViewController,
                            animated: Bool,
                            completion: @escaping (_: ActionResult) -> Void) {
            guard !splitViewController.viewControllers.isEmpty else {
                completion(.failure("Master view controller is not set in  \(splitViewController) to present a detail view controller \(viewController)."))
                return
            }

            splitViewController.showDetailViewController(viewController, sender: nil)
            completion(.continueRouting)
        }
    }

    /// Presents a master view controller in the `UISplitViewController`
    public struct SetAsMasterAction<SC: Container>: ContainerAction where SC.ViewController: UISplitViewController {

        /// Constructor
        init() {
        }

        public func perform(embedding viewController: UIViewController, in childViewControllers: inout [UIViewController]) {
            if !childViewControllers.isEmpty {
                childViewControllers.insert(viewController, at: 0)
            } else {
                childViewControllers.append(viewController)
            }
        }

        public func perform(with viewController: UIViewController,
                            on splitViewController: SC.ViewController,
                            animated: Bool,
                            completion: @escaping (_: ActionResult) -> Void) {
            guard !splitViewController.viewControllers.isEmpty else {
                completion(.failure("Could not find UISplitViewController in \(splitViewController) to present master view controller \(viewController)."))
                return
            }

            splitViewController.viewControllers[0] = viewController
            completion(.continueRouting)
        }

    }

}
