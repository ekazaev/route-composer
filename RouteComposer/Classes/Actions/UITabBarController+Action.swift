//
// Created by Eugene Kazaev on 2018-09-18.
//

import Foundation
import UIKit

/// Actions for UITabBarController
extension Container where Self.ViewController: UITabBarController {

    /// Presents a detail view controller in the `UISplitViewController`
    public static func addTab(at tabIndex: Int, replacing: Bool = false) -> UITabBarController.AddTabAction<Self> {
        return UITabBarController.AddTabAction<Self>(at: tabIndex, replacing: replacing)
    }

    /// Integrates a `UIViewController` in to a `UITabBarController`
    ///
    ///   - tabIndex: index of the tab after which one a view controller should be added.
    ///     If has not been passed - a view controller
    ///   will be added after the latest one.
    public static func addTab(at tabIndex: Int? = nil) -> UITabBarController.AddTabAction<Self> {
        return UITabBarController.AddTabAction<Self>(at: tabIndex)
    }

}