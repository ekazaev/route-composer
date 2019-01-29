//
// Created by Eugene Kazaev on 19/12/2017.
// Copyright (c) 2017 HBC Tech. All rights reserved.
//

import Foundation
import UIKit

/// `UIWindow` helper functions.
public extension UIWindow {

    /// The topmost `UIViewController` in the view controller stack.
    var topmostViewController: UIViewController? {
        var topmostViewController = rootViewController

        while let presentedViewController = topmostViewController?.presentedViewController, !presentedViewController.isBeingDismissed {
            topmostViewController = presentedViewController
        }

        return topmostViewController
    }

}
