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

    // ###NB
    // `UISplitViewController` does not support showing primary view controller overlay programmatically out of the box in .primaryOverlay
    // mode, so `makeVisible` wont be able to serve it.
    //
    // However, it can serve some edge cases when `UISplitViewController` is collapsed and primary view controller is `UINavigationController`.
    public func makeVisible(_ viewController: UIViewController, animated: Bool) {
        guard UIViewController.findViewController(in: self, options: [.contained], using: { $0 === viewController }) != nil else {
            return
        }
        if isCollapsed {
            guard viewController.navigationController?.visibleViewController != viewController else {
                return
            }
            viewController.navigationController?.popToViewController(viewController, animated: animated)
        }
    }

    // Replacing of the child view controllers is not fully supported by the implementation of `UISplitViewController`.
    // Only some common cases are covered by this method.
    //
    // ###NB
    // Please read: https://developer.apple.com/documentation/uikit/uisplitviewcontroller
    //
    // Quote:
    // When designing your split view interface, it is best to install primary and secondary view controllers that do not change.
    // A common technique is to install navigation controllers in both positions and then push and pop new content as needed.
    public func replace(containedViewControllers: [UIViewController], animated: Bool, completion: @escaping () -> Void) {
        if containedViewControllers.count > 1,
           let primaryViewController = self.containedViewControllers.first,
           primaryViewController === containedViewControllers.first,
           let detailsViewController = containedViewControllers.last {
            showDetailViewController(detailsViewController, sender: self)
        } else {
            viewControllers = containedViewControllers
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
