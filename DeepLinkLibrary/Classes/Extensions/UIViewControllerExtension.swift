//
// Created by Eugene Kazaev on 19/12/2017.
// Copyright (c) 2017 Gilt Groupe. All rights reserved.
//

//import Foundation

import UIKit

public enum ViewControllerSearchOptions {

    case sameLevel

    case sameAndUp

    case sameAndDown
}

public extension UIViewController {

    public static func findParentViewController(from vc: UIViewController, using comparator: (UIViewController) -> Bool) -> UIViewController? {
        if comparator(vc) {
            return vc
        }

        if let parentVC = vc.parent {
            return findParentViewController(from: parentVC, using: comparator)
        }

        return nil
    }

    public static func findViewController(in vc: UIViewController, options: ViewControllerSearchOptions = .sameAndUp, using comparator: (UIViewController) -> Bool) -> UIViewController? {
        if comparator(vc) {
            return vc
        }

        if let nc = vc as? UINavigationController {
            for selected in nc.viewControllers {
                if let found = findViewController(in: selected, options: .sameLevel, using: comparator) {
                    return found
                }
            }
        } else if let tbc = vc as? UITabBarController, let viewControllers = tbc.viewControllers {
            for selected in viewControllers {
                if let found = findViewController(in: selected, options: .sameLevel, using: comparator) {
                    return found
                }
            }
        } else if let svc = vc as? UISplitViewController {
            let viewControllers = svc.viewControllers
            for selected in viewControllers {
                if let found = findViewController(in: selected, options: .sameLevel, using: comparator) {
                    return found
                }
            }
        } else {
            for child in vc.childViewControllers {
                if let found = findViewController(in: child, options: .sameLevel, using: comparator) {
                    return found
                }
            }
        }

        if options == .sameAndUp,
           let presented = vc.presentedViewController,
           !presented.isBeingDismissed && presented.popoverPresentationController == nil,
           let found = findViewController(in: presented, options: options, using: comparator) {
            return found
        } else if options == .sameAndDown {
            if let presenting = vc.presentingViewController,
               !vc.isBeingDismissed && vc.popoverPresentationController == nil,
                let found = findViewController(in: presenting, options: options, using: comparator) {
                return found
            }
        }

        return nil
    }

    public func dismissAllPresentedControllers(animated: Bool, completion: (() -> Void)?) {
        UIViewController.dismissAllPresentedViewControllers(starting: self, animated: animated, completion: completion)
    }

    public static func dismissAllPresentedViewControllers(starting vc: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if let presentedViewController = vc.presentedViewController {
            presentedViewController.dismissAllPresentedControllers(animated: animated) {
                presentedViewController.dismiss(animated: animated) {
                    completion?()
                }
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
