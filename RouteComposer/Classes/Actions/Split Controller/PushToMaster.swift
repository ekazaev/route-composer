//
// Created by Eugene Kazaev on 23/01/2018.
//

import Foundation
import UIKit

/// Presents a master view controller in the `UISplitViewController`
public extension SplitControllerFactory {

    /// Presents a master view controller in the `UISplitViewController`
    public struct PushToMaster: ContainerAction {

        public typealias SupportedContainer = SplitControllerFactory

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
                            on splitViewController: UISplitViewController,
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
