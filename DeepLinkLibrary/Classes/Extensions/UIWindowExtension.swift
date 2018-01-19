//
// Created by Eugene Kazaev on 19/12/2017.
// Copyright (c) 2017 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

extension UIWindow {

    /** The application's `keyWindow`, or `nil` if there isn't one. */
    public static var key: UIWindow? {
        return UIApplication.shared.keyWindow
    }

    private func findPresentedViewController(_ viewController: UIViewController) -> UIViewController {
        if let presentedViewContorller = viewController.presentedViewController,
           !presentedViewContorller.isBeingDismissed && presentedViewContorller.popoverPresentationController == nil {
            return findPresentedViewController(presentedViewContorller)
        }

        return viewController
    }

    public var topmostViewController: UIViewController? {
        guard let rootViewController = rootViewController else {
            return nil
        }

        return findPresentedViewController(rootViewController)
    }

    private func findPresentedNonContainerViewController(_ vc: UIViewController) -> UIViewController {
        if let presented = vc.presentedViewController,
           !presented.isBeingDismissed && presented.popoverPresentationController == nil {
            return findPresentedNonContainerViewController(presented)
        }

        if let nc = vc as? UINavigationController {
            if let visible = nc.topViewController {
                return findPresentedNonContainerViewController(visible)
            }
        } else if let tbc = vc as? UITabBarController {
            if let selected = tbc.selectedViewController {
                return findPresentedNonContainerViewController(selected)
            }
        } else if let svc = vc as? UISplitViewController {
            if let selected = svc.isCollapsed ? svc.viewControllers.last : svc.viewControllers.first {
                return findPresentedNonContainerViewController(selected)
            }
        }

        return vc
    }

    public var topmostNonContainerViewController: UIViewController? {
        guard let rootVC = rootViewController else {

            return nil
        }

        let mpc = findPresentedNonContainerViewController(rootVC)

        return mpc
    }


}
