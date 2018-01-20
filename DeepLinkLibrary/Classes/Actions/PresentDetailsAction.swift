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
    
    public func applyMerged(viewController: UIViewController, containerViewControllers: inout [UIViewController], logger: Logger?) {
        containerViewControllers.append(viewController)
    }

    public func apply(viewController: UIViewController, on existingController: UIViewController, logger: Logger?, completion: @escaping (_: UIViewController) -> Void) {
        guard let splitViewController = existingController as? UISplitViewController ?? existingController.splitViewController,
              splitViewController.viewControllers.count > 0 else {
            logger?.log(.error("Could not find UISplitViewController in \(existingController) to present master view controller \(viewController)."))
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
    
    public func applyMerged(viewController: UIViewController, containerViewControllers: inout [UIViewController], logger: Logger?) {

    }

    public func apply(viewController: UIViewController, on existingController: UIViewController, logger: Logger?, completion: @escaping (_: UIViewController) -> Void) {
        guard let splitViewController = existingController as? UISplitViewController ?? existingController.splitViewController,
              splitViewController.viewControllers.count > 0 else {
            logger?.log(.error("Could not find UISplitViewController in \(existingController) to present details view controller \(viewController)."))
            completion(existingController)
            return
        }

        splitViewController.showDetailViewController(viewController, sender: nil)
        completion(viewController)
    }
}
