//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

/// Holder of default actions that can be applied to any `UIViewController`.
public extension GeneralAction {

    /// Replaces root view controller in key `UIWindow`
    public class ReplaceRoot: Action {

        /// Constructor
        public init() {
        }

        public func perform(embedding viewController: UIViewController, in containerViewControllers: inout [UIViewController]) {
            fatalError("Can not be merged")
        }

        public func perform(viewController: UIViewController, on existingController: UIViewController, animated: Bool, completion: @escaping(_: ActionResult) -> Void) {
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
