//
// Created by Eugene Kazaev on 2018-09-18.
//

import Foundation
import UIKit

/// Actions for `UINavigationController`
extension Container where Self.ViewController: UINavigationController {

    /// Replaces all the child view controllers in the `UINavigationController`'s children stack
    public static func pushAsRoot() -> UINavigationController.PushAsRootAction<Self.ViewController> {
        return UINavigationController.PushAsRootAction()
    }

    /// Pushes a child view controller into the `UINavigationController`'s children stack
    public static func pushToNavigation() -> UINavigationController.PushAction<Self.ViewController> {
        return UINavigationController.PushAction()
    }

    /// Pushes a child view controller, replacing the existing, into the `UINavigationController`'s children stack
    public static func pushReplacingLast() -> UINavigationController.PushReplacingLastAction<Self.ViewController> {
        return UINavigationController.PushReplacingLastAction()
    }

}
