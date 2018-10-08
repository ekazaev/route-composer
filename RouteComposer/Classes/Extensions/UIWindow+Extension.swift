//
// Created by Eugene Kazaev on 19/12/2017.
// Copyright (c) 2017 HBC Tech. All rights reserved.
//

import Foundation
import UIKit

extension UIWindow {

    /// The application's `keyWindow`, or `nil` if there isn't one.
    public static var key: UIWindow? {
        return UIApplication.shared.keyWindow
    }

    /// The topmost `UIViewController` in the view controller stack.
    public var topmostViewController: UIViewController? {
        var topmostViewController = rootViewController

        while let presentedViewController = topmostViewController?.presentedViewController, !presentedViewController.isBeingDismissed {
            topmostViewController = presentedViewController
        }

        return topmostViewController
    }

}
