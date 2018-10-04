//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import UIKit
import RouteComposer
import os.log

extension Router {

    func navigate<VC: UIViewController, C>(to destination: ExampleDestination<VC, C>, animated: Bool = true, completion: ((_: RoutingResult) -> Void)? = nil) throws {
        try self.navigate(to: destination.step, with: destination.context, animated: animated, completion: completion)
    }

    func navigate<ViewController: UIViewController, Context>(to step: DestinationStep<ViewController, Context>, with context: Context) throws {
        try self.navigate(to: step, with: context, animated: true, completion: nil)
    }

}

extension UIViewController {

    static let router: Router = {
        let appRouterLogger: DefaultLogger
        if #available(iOS 10, *) {
            appRouterLogger = DefaultLogger(.verbose, osLog: OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "Router"))
        } else {
            appRouterLogger = DefaultLogger(.verbose)
        }
        return AnalyticsRouterDecorator(router: DefaultRouter(logger: appRouterLogger))
    }()

    var router: Router {
        return UIViewController.router
    }

}

extension UIViewController {

    private func findPresentedNonContainerViewController(_ viewController: UIViewController) -> UIViewController {
        if let presented = viewController.presentedViewController, !presented.isBeingDismissed {
            return findPresentedNonContainerViewController(presented)
        }

        if let navigationController = viewController as? UINavigationController {
            if let visible = navigationController.topViewController {
                return findPresentedNonContainerViewController(visible)
            }
        } else if let tabBarController = viewController as? UITabBarController {
            if let selected = tabBarController.selectedViewController {
                return findPresentedNonContainerViewController(selected)
            }
        } else if let splitViewController = viewController as? UISplitViewController {
            if let selected = splitViewController.isCollapsed ? splitViewController.viewControllers.last : splitViewController.viewControllers.first {
                return findPresentedNonContainerViewController(selected)
            }
        }

        return viewController
    }

    public var topmostNonContainerViewController: UIViewController? {
        guard let rootViewController = UIWindow.key?.rootViewController else {

            return nil
        }

        return findPresentedNonContainerViewController(rootViewController)
    }

}
