//
// Created by Eugene Kazaev on 2018-09-18.
//

import Foundation
import UIKit

/// Actions for `UITabBarController`
extension Container where Self.ViewController: UITabBarController {

    /// Adds a `UIViewController` to a `UITabBarController`
    ///
    ///   - tabIndex: index of a tab.
    ///   - replacing: should be set to `true` if an existing view controller should be replaced.
    ///     If condition has not been passed, a view controller
    ///   will be added after the latest one.
    public static func addTab(at tabIndex: Int, replacing: Bool = false) -> UITabBarController.AddTabAction<Self.ViewController> {
        return UITabBarController.AddTabAction(at: tabIndex, replacing: replacing)
    }

    /// Adds a `UIViewController` to a `UITabBarController`
    ///
    ///   - tabIndex: index of a tab.
    ///     If condition has not been passed, a view controller
    ///   will be added after the latest one.
    public static func addTab(at tabIndex: Int? = nil) -> UITabBarController.AddTabAction<Self.ViewController> {
        return UITabBarController.AddTabAction(at: tabIndex)
    }

}
