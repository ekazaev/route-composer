//
// Created by Eugene Kazaev on 19/12/2017.
// Copyright (c) 2017 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

extension UIWindow {

    /** The application's `keyWindow`, or `nil` if there isn't one. */
    public static var key: UIWindow? {
        return UIApplication.shared.keyWindow
    }

    private func findPresentedViewController(_ viewController: UIViewController) -> UIViewController {
        if let presentedViewContorller = viewController.presentedViewController,
           !presentedViewContorller.isBeingDismissed && presentedViewContorller.popoverPresentationController == nil {
            return findPresentedViewController(presentedViewContorller)
        }

        return viewController
    }

    public var topmostViewController: UIViewController? {
        guard let rootViewController = rootViewController else {
            return nil
        }

        return findPresentedViewController(rootViewController)
    }


}
