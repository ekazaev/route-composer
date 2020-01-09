//
// Created by Eugene Kazaev on 19/12/2017.
//

#if os(iOS)

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

#endif
