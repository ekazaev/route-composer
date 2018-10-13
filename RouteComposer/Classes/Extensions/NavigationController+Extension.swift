//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit

/// - The `UINavigationController` extension is to support the `ContainerViewController` protocol
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
        guard visibleViewController != viewController else {
            return
        }
        for containingViewController in containingViewControllers where containingViewController == viewController {
            self.popToViewController(containingViewController, animated: animated)
            return
        }
    }

}

/// - The `UINavigationController` extension is to support the `RoutingInterceptable` protocol
extension UINavigationController: RoutingInterceptable {

    public var canBeDismissed: Bool {
        return containingViewControllers.canBeDismissed
    }

}
