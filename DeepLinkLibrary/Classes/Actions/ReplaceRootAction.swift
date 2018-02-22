//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

public class ReplaceRootAction: Action {

    public init() {
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
