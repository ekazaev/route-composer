//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright © 2018 HBC Digital. All rights reserved.
//

import Foundation
import UIKit

/// - The `UINavigationController` extension is to support the `ContainerViewController` protocol
extension UINavigationController: ContainerViewController {

    public var containedViewControllers: [UIViewController] {
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
        for containedViewController in containedViewControllers where containedViewController == viewController {
            self.popToViewController(containedViewController, animated: animated)
            return
        }
    }

}

/// - The `UINavigationController` extension is to support the `RoutingInterceptable` protocol
extension UINavigationController: RoutingInterceptable {

    public var canBeDismissed: Bool {
        return containedViewControllers.canBeDismissed
    }

}
