//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit
import DeepLinkLibrary

private let appRouter = DefaultRouter(logger: DefaultLogger(.verbose))

extension UIViewController {

    var router: DefaultRouter {
        get {
            return appRouter
        }
    }
}


extension UIViewController {

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
        guard let rootVC = UIWindow.key?.rootViewController else {

            return nil
        }

        let mpc = findPresentedNonContainerViewController(rootVC)

        return mpc
    }
}