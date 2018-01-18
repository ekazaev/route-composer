//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

public class PushAction: ViewControllerAction {
    public init() {
        
    }
    
    public func applyMerged(viewController: UIViewController) {

    }

    public func apply(viewController: UIViewController, on existingController: UIViewController, completion: @escaping(_: UIViewController) -> Void) {
        if let nv = existingController as? UINavigationController ?? existingController.navigationController {
            nv.pushViewController(viewController, animated: true)
            return completion(viewController)
        }

        return completion(existingController)
    }

}
