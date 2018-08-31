//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit

/// - The `UITabBarController` extension to support the `ContainerViewController` protocol
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
        for containingViewController in containingViewControllers where containingViewController == viewController {
            self.selectedViewController = containingViewController
            return
        }
    }

}

/// - The `UITabBarController` extension to support the `RoutingInterceptable` protocol
extension UITabBarController: RoutingInterceptable {

    public var canBeDismissed: Bool {
        return containingViewControllers.canBeDismissed
    }

}
