//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit

/// Presents a detail view controller in the `UISplitViewController`
public extension SplitControllerFactory {

    /// Presents a detail view controller in the `UISplitViewController`
    public struct PushToDetails: ContainerAction {

        public typealias SupportedContainer = SplitControllerFactory

        /// Constructor
        public init() {
        }

        public func perform(with viewController: UIViewController,
                            on splitViewController: UISplitViewController,
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

}
