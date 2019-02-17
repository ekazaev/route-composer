//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright © 2018 HBC Digital. All rights reserved.
//

import Foundation
import UIKit

/// - The `UITabBarController` extension is to support the `ContainerViewController` protocol
extension UITabBarController: ContainerViewController {

    public var containedViewControllers: [UIViewController] {
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
        for containedViewController in containedViewControllers where containedViewController == viewController {
            self.selectedViewController = containedViewController
            return
        }
    }

    public func replace(containedViewControllers: [UIViewController], animated: Bool, completion: @escaping () -> Void) {
        setViewControllers(containedViewControllers, animated: animated)
        completion()
    }

}

/// - The `UITabBarController` extension is to support the `RoutingInterceptable` protocol
extension UITabBarController: RoutingInterceptable {

    public var canBeDismissed: Bool {
        return containedViewControllers.canBeDismissed
    }

}
