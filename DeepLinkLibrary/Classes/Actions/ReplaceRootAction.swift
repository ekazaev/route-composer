//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

/// Replaces root view controller of key UIWindow.
public class ReplaceRootAction: Action {

    /// Constructor
    public init() {
    }

    public func performMerged(viewController: UIViewController, containerViewControllers: inout [UIViewController]) {
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
