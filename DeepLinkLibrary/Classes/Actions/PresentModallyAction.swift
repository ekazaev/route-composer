//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

public class PresentModallyAction: Action {

    public init() {
        
    }
    
    public func applyMerged(viewController: UIViewController, in existingController: UIViewController) {

    }

    public func apply(viewController: UIViewController, on existingController: UIViewController, completion: @escaping (_: UIViewController) -> Void) {
        existingController.present(viewController, animated: true, completion: {
            completion(viewController)
        })
    }

}
