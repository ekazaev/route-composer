//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit

// - The `UISplitViewController` extension is to support the `ContainerViewController` protocol
extension UISplitViewController: ContainerViewController {

    public var containingViewControllers: [UIViewController] {
        return viewControllers
    }

    public var visibleViewControllers: [UIViewController] {
        return containingViewControllers
    }

    public func makeVisible(_ viewController: UIViewController, animated: Bool) {
        guard viewController.navigationController?.navigationController?.visibleViewController != viewController else {
            return
        }
        for containingViewController in containingViewControllers where containingViewController == viewController {
            containingViewController.navigationController?.navigationController?.popToViewController(containingViewController, animated: animated)
            return
        }
    }

}

// - The `UISplitViewController` extension is to support the `RoutingInterceptable` protocol
extension UISplitViewController: RoutingInterceptable {

    public var canBeDismissed: Bool {
        return containingViewControllers.canBeDismissed
    }

}
