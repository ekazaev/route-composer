//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import UIKit
import RouteComposer
import os.log


extension UIViewController {
    
    static let router: DefaultRouter = {
        let appRouterLogger: DefaultLogger
        if #available(iOS 10, *) {
            appRouterLogger = DefaultLogger(.verbose, osLog: OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "Router"))
        } else {
            appRouterLogger = DefaultLogger(.verbose)
        }
        var router = DefaultRouter(logger: appRouterLogger)
        router.add(GlobalInterceptor())
        router.add(GlobalPostTask())
        router.add(GlobalContextTask())
        return router
    }()
    
    var router: DefaultRouter {
        return UIViewController.router
    }
}


extension UIViewController {

    private func findPresentedNonContainerViewController(_ vc: UIViewController) -> UIViewController {
        if let presented = vc.presentedViewController, !presented.isBeingDismissed{
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
