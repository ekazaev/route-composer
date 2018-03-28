//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

/// - UINavigationController extension to support ContainerViewController protocol
extension UINavigationController: ContainerViewController {

    public var containingViewControllers: [UIViewController] {
        return viewControllers
    }

    public var visibleViewControllers: [UIViewController] {
        guard let visibleViewController = visibleViewController else {
            return []
        }
        return [visibleViewController]
    }

    public func makeVisible(_ viewController: UIViewController, animated: Bool) {
        for vc in containingViewControllers {
            if vc == viewController {
                self.popToViewController(vc, animated: animated)
                return
            }
        }
    }

}

/// - Navigation controller extension to support RouterRulesSupport protocol
extension UINavigationController: RoutingInterceptable {

    public var canBeDismissed: Bool {
        return containingViewControllers.canBeDismissed
    }

}
