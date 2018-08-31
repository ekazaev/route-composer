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

    /// The topmost `UIViewController` in the view controller stack. E.g - top most presented one.
    public var topmostViewController: UIViewController? {
        guard let rootViewController = rootViewController else {
            return nil
        }

        return findPresentedViewController(rootViewController)
    }

    private func findPresentedViewController(_ viewController: UIViewController) -> UIViewController {
        if let presentedViewController = viewController.presentedViewController,
           !presentedViewController.isBeingDismissed {
            return findPresentedViewController(presentedViewController)
        }

        return viewController
    }

}
