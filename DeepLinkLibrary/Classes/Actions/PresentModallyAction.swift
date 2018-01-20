//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

public class PresentModallyAction: ViewControllerAction {

    public init() {
        
    }
    
    public func applyMerged(viewController: UIViewController, containerViewControllers: inout [UIViewController], logger: Logger?) {

    }

    public func apply(viewController: UIViewController, on existingController: UIViewController, logger: Logger?, completion: @escaping (_: UIViewController) -> Void) {
        guard existingController.presentedViewController == nil else {
            logger?.log(.error("Could not present modally \(viewController) from \(existingController) because it has already presented a view controller."))
            completion(existingController)
            return
        }
        existingController.present(viewController, animated: true, completion: {
            completion(viewController)
        })
    }

}
