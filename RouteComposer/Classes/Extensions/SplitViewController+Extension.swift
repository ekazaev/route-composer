//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit


// - `UISplitViewController` extension to support `ContainerViewController` protocol
extension UISplitViewController: ContainerViewController {

    public var containingViewControllers: [UIViewController] {
        return viewControllers
    }

    public var visibleViewControllers: [UIViewController] {
        return containingViewControllers
    }

    public func makeVisible(_ viewController: UIViewController, animated: Bool) {
        for vc in containingViewControllers {
            if vc == viewController {
                vc.navigationController?.navigationController?.popToViewController(vc, animated: animated)
                return
            }
        }
    }

}

// - `UISplitViewController` extension to support `RoutingInterceptable` protocol
extension UISplitViewController: RoutingInterceptable {

    public var canBeDismissed: Bool {
        return containingViewControllers.canBeDismissed
    }

}
