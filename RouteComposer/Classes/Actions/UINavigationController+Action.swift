//
// Created by Eugene Kazaev on 2018-09-18.
//

import Foundation
import UIKit

/// Actions for UINavigationController
extension Container where Self.ViewController: UINavigationController {

    /// Replaces all the child view controllers in the `UINavigationController`'s child stack
    public static func pushAsRoot() -> UINavigationController.PushAsRootAction<Self.ViewController> {
        return UINavigationController.PushAsRootAction()
    }

    /// Replaces all the child view controllers in the `UINavigationController`'s child stack
    public static func pushToNavigation() -> UINavigationController.PushAction<Self.ViewController> {
        return UINavigationController.PushAction()
    }

    /// Replaces all the child view controllers in the `UINavigationController`'s child stack
    public static func pushReplacingLast() -> UINavigationController.PushReplacingLastAction<Self.ViewController> {
        return UINavigationController.PushReplacingLastAction()
    }

}
