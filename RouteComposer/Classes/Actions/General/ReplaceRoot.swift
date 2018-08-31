//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit

/// Just a wrapper for the general actions that can be applied to any `UIViewController`
public extension GeneralAction {

    /// Replaces the root view controller in the key `UIWindow`
    public struct ReplaceRoot: Action {

        /// Constructor
        public init() {
        }

        public func perform(embedding viewController: UIViewController,
                            in childViewControllers: inout [UIViewController]) {
            assertionFailure("\(#function) is not eligible for this action.")
        }

        public func perform(with viewController: UIViewController,
                            on existingController: UIViewController,
                            animated: Bool,
                            completion: @escaping(_: ActionResult) -> Void) {
            guard let window = UIWindow.key else {
                completion(.failure("Key window not found."))
                return
            }

            window.rootViewController = viewController
            window.makeKeyAndVisible()
            return completion(.continueRouting)
        }

    }

}
