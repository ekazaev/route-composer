//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

public class ReplaceRootAction: ViewControllerAction {

    public init() {
        
    }
    
    public func applyMerged(viewController: UIViewController, containerViewControllers: inout [UIViewController], logger: Logger?) {

    }

    public func apply(viewController: UIViewController, on existingController: UIViewController, animated: Bool, logger: Logger?, completion: @escaping(_: UIViewController) -> Void) {
        guard let window = UIWindow.key else {
            completion(existingController)
            return
        }

        window.rootViewController = viewController
        window.makeKeyAndVisible()
        return completion(viewController)
    }
}
