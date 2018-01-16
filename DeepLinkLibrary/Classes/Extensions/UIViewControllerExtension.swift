//
// Created by Eugene Kazaev on 19/12/2017.
// Copyright (c) 2017 Gilt Groupe. All rights reserved.
//

//import Foundation

import UIKit

public extension UIViewController {

    public static func findViewControllerUp(from vc: UIViewController, using equator: (UIViewController) -> Bool) -> UIViewController? {
        if equator(vc) {
            return vc
        }

        if let parentVC = vc.parent {
            return findViewControllerUp(from: parentVC, using: equator)
        }

        return nil
    }

    public static func findViewControllerDeep(in vc: UIViewController, oneLevelOnly: Bool = false, using equator: (UIViewController) -> Bool) -> UIViewController? {
        if equator(vc) {
            return vc
        }

        if let nc = vc as? UINavigationController {
            for selected in nc.viewControllers {
                if let found = findViewControllerDeep(in: selected, oneLevelOnly: oneLevelOnly, using: equator) {
                    return found
                }
            }
        } else if let tbc = vc as? UITabBarController, let viewControllers = tbc.viewControllers {
            for selected in viewControllers {
                if let found = findViewControllerDeep(in: selected, oneLevelOnly: oneLevelOnly, using: equator) {
                    return found
                }
            }
        } else if let svc = vc as? UISplitViewController {
            let viewControllers = svc.viewControllers
            for selected in viewControllers {
                if let found = findViewControllerDeep(in: selected, oneLevelOnly: oneLevelOnly, using: equator) {
                    return found
                }
            }
        }

        if !oneLevelOnly,
           let presented = vc.presentedViewController,
           !presented.isBeingDismissed && presented.popoverPresentationController == nil {
            return findViewControllerDeep(in: presented, oneLevelOnly: oneLevelOnly, using: equator)
        }

        for child in vc.childViewControllers {
            return findViewControllerDeep(in: child, oneLevelOnly: oneLevelOnly, using: equator)
        }

        return nil
    }

    public func dismissAllPresentedControllers(animated: Bool, completion: (() -> Void)?) {
        UIViewController.dismissAllPresentedViewControllers(starting: self, animated: animated, completion: completion)
    }

    public static func dismissAllPresentedViewControllers(starting vc: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if let presentedViewController = vc.presentedViewController {
            presentedViewController.dismiss(animated: animated) {
                completion?()
            }
        } else {
            completion?()
        }
    }

    public static func findAllPresentedViewControllers(starting vc: UIViewController, found: [UIViewController] = []) -> [UIViewController] {
        var found = found
        if let presentedViewController = vc.presentedViewController {
            found.append(presentedViewController)
            return findAllPresentedViewControllers(starting: presentedViewController, found: found)
        } else {
            return found
        }
    }
}
