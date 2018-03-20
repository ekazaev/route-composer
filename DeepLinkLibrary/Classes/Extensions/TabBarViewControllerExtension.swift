//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

/// - UITabBarController extension to support ContainerViewController protocol
extension UITabBarController: ContainerViewController {

    public var containingViewControllers: [UIViewController] {
        guard let viewControllers = self.viewControllers else {
            return []
        }
        return viewControllers
    }

    public var visibleViewControllers: [UIViewController] {
        guard let visibleViewController = selectedViewController else {
            return []
        }
        return [visibleViewController]
    }

    public func makeVisible(viewController: UIViewController, animated: Bool) {
        for vc in containingViewControllers {
            if vc == viewController {
                self.selectedViewController = vc
                return
            }
        }
    }

}

/// - UITabBarController extension to support RouterRulesSupport protocol
extension UITabBarController: RouterRulesSupport {

    public var canBeDismissed: Bool {
        return containingViewControllers.canBeDismissed
    }

}
