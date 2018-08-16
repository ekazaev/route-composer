//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit

/// - `UITabBarController` extension to support `ContainerViewController` protocol
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

    public func makeVisible(_ viewController: UIViewController, animated: Bool) {
        guard selectedViewController != viewController else {
            return
        }
        for vc in containingViewControllers {
            if vc == viewController {
                self.selectedViewController = vc
                return
            }
        }
    }

}

/// - `UITabBarController` extension to support `RoutingInterceptable` protocol
extension UITabBarController: RoutingInterceptable {

    public var canBeDismissed: Bool {
        return containingViewControllers.canBeDismissed
    }

}
