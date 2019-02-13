//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright © 2018 HBC Digital. All rights reserved.
//

import Foundation
import UIKit

// - The `UISplitViewController` extension is to support the `ContainerViewController` protocol
extension UISplitViewController: ContainerViewController {

    public var containedViewControllers: [UIViewController] {
        return viewControllers
    }

    public var visibleViewControllers: [UIViewController] {
        return containedViewControllers
    }

    public func makeVisible(_ viewController: UIViewController, animated: Bool) {
        guard viewController.navigationController?.navigationController?.visibleViewController != viewController else {
            return
        }
        for containedViewController in containedViewControllers where containedViewController == viewController {
            containedViewController.navigationController?.navigationController?.popToViewController(containedViewController, animated: animated)
            return
        }
//        if let index = containedViewControllers.firstIndex(of: viewController) {
//            if index == 1, let masterViewController = containedViewControllers.first {
//                show(masterViewController, sender: self)
//            } else if let detailsViewController = containedViewControllers.last {
//                showDetailViewController(detailsViewController, sender: self)
//            }
//        }
    }

    public func replace(containedViewControllers: [UIViewController], animated: Bool, completion: () -> Void) {
        viewControllers = containedViewControllers
        if !containedViewControllers.isEmpty {
            // Do not really understand about presenting master
/*            if containedViewControllers.count == 1, let masterViewController = containedViewControllers.first {
                show(masterViewController, sender: self)
            } else */ if let detailsViewController = containedViewControllers.last {
                showDetailViewController(detailsViewController, sender: self)
            }
        }
        completion()
    }

}

// - The `UISplitViewController` extension is to support the `RoutingInterceptable` protocol
extension UISplitViewController: RoutingInterceptable {

    public var canBeDismissed: Bool {
        return containedViewControllers.canBeDismissed
    }

}
