//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

// TODO: Undone
public class PresentMasterAction: ViewControllerAction {

    public init() {
        
    }
    
    public func applyMerged(viewController: UIViewController, in existingController: UIViewController) {

    }

    public func apply(viewController: UIViewController, on existingController: UIViewController, completion: @escaping (_: UIViewController) -> Void) {
        guard let splitViewController = existingController as? UISplitViewController ?? existingController.splitViewController,
              splitViewController.viewControllers.count > 0 else {
            completion(existingController)
            return
        }

        splitViewController.viewControllers[0] = viewController
        completion(viewController)
    }
}

public class PresentDetailsAction: ViewControllerAction {

    public init() {
        
    }
    
    public func applyMerged(viewController: UIViewController, in existingController: UIViewController) {

    }

    public func apply(viewController: UIViewController, on existingController: UIViewController, completion: @escaping (_: UIViewController) -> Void) {
        guard let splitViewController = existingController as? UISplitViewController ?? existingController.splitViewController,
              splitViewController.viewControllers.count > 0 else {
            completion(existingController)
            return
        }

        splitViewController.showDetailViewController(viewController, sender: nil)
        completion(viewController)
    }
}
