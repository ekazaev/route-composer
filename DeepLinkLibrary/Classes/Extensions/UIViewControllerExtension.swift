//
// Created by Eugene Kazaev on 19/12/2017.
// Copyright (c) 2017 Gilt Groupe. All rights reserved.
//

//import Foundation

import UIKit

/// findViewController methods search options
///
/// - current: Search on the a current level but do not look in presented or presenting stacks.
/// - currentAndUp: Start to search on the current level an go all the way down to the root view controller of the window
/// - currentAndDown: Start at the root view controller of the window and search all the way up to the last
///   presented stack
public enum ViewControllerSearchOptions {

    case current

    case currentAndUp

    case currentAndDown

}

public extension UIViewController {

    public static func findViewController(in vc: UIViewController, options: ViewControllerSearchOptions = .currentAndUp, using comparator: (UIViewController) -> Bool) -> UIViewController? {
        if comparator(vc) {
            return vc
        }

        if let container = vc as? ContainerViewController {
            for selected in Array([container.visibleViewControllers, container.containingViewControllers].joined()).uniqElements() {
                if let found = findViewController(in: selected, options: .current, using: comparator) {
                    return found
                }
            }
        }

        if options == .currentAndUp,
           let presented = vc.presentedViewController,
           !presented.isBeingDismissed && presented.popoverPresentationController == nil,
           let found = findViewController(in: presented, options: options, using: comparator) {
            return found
        } else if options == .currentAndDown {
            if let presenting = vc.presentingViewController,
               !vc.isBeingDismissed && vc.popoverPresentationController == nil,
                let found = findViewController(in: presenting, options: options, using: comparator) {
                return found
            }
        }

        return nil
    }

    internal var allPresentedViewControllers: [UIViewController] {
        return UIViewController.findAllPresentedViewControllers(starting: self)
    }

    private static func findParentViewController(from vc: UIViewController, using comparator: (UIViewController) -> Bool) -> UIViewController? {
        if comparator(vc) {
            return vc
        }

        if let parentVC = vc.parent {
            return findParentViewController(from: parentVC, using: comparator)
        }

        return nil
    }

    internal func dismissAllPresentedControllers(animated: Bool, completion: (() -> Void)?) {
        if let _ = self.presentedViewController {
            self.dismiss(animated: animated) {
                completion?()
            }
        } else {
            completion?()
        }
    }

    private static func findAllPresentedViewControllers(starting vc: UIViewController, found: [UIViewController] = []) -> [UIViewController] {
        var found = found
        if let presentedViewController = vc.presentedViewController {
            found.append(presentedViewController)
            return findAllPresentedViewControllers(starting: presentedViewController, found: found)
        } else {
            return found
        }
    }
}
