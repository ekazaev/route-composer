//
// Created by Eugene Kazaev on 2018-09-18.
//

import Foundation
import UIKit

/// Actions for `UISplitViewController`
public extension ContainerViewController where Self: UISplitViewController {

    /// Presents a view controller as a master in the `UISplitViewController`
    public static func setAsMaster() -> SplitViewControllerActions.SetAsMasterAction<Self> {
        return SplitViewControllerActions.SetAsMasterAction()
    }

    /// Presents a view controller as a detail in the `UISplitViewController`
    public static func pushToDetails() -> SplitViewControllerActions.PushToDetailsAction<Self> {
        return SplitViewControllerActions.PushToDetailsAction()
    }

}

/// Actions for `UISplitViewController`
public struct SplitViewControllerActions {

    /// Presents a detail view controller in the `UISplitViewController`
    public struct PushToDetailsAction<ViewController: UISplitViewController>: ContainerAction {

        /// Constructor
        init() {
        }

        public func perform(with viewController: UIViewController,
                            on splitViewController: ViewController,
                            animated: Bool,
                            completion: @escaping (_: ActionResult) -> Void) {
            guard !splitViewController.viewControllers.isEmpty else {
                completion(.failure(RoutingError.compositionFailed(RoutingError.Context(debugDescription: "Master view controller is not set in " +
                        "\(splitViewController) to present a detail view controller \(viewController)."))))
                return
            }

            splitViewController.showDetailViewController(viewController, sender: nil)
            completion(.continueRouting)
        }
    }

    /// Presents a master view controller in the `UISplitViewController`
    public struct SetAsMasterAction<ViewController: UISplitViewController>: ContainerAction {

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
                            on splitViewController: ViewController,
                            animated: Bool,
                            completion: @escaping (_: ActionResult) -> Void) {
            splitViewController.viewControllers[0] = viewController
            completion(.continueRouting)
        }

    }

}
