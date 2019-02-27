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
        guard visibleViewController != viewController,
              let viewControllerToMakeVisible = containedViewControllers.first(where: { $0 == viewController }) else {
            return
        }
        self.popToViewController(viewControllerToMakeVisible, animated: animated)
    }

    public func replace(containedViewControllers: [UIViewController], animated: Bool, completion: @escaping () -> Void) {
        setViewControllers(containedViewControllers, animated: animated)
        completion()
    }

}

/// - The `UINavigationController` extension is to support the `RoutingInterceptable` protocol
extension UINavigationController: RoutingInterceptable {

    public var canBeDismissed: Bool {
        return containedViewControllers.canBeDismissed
    }

}
