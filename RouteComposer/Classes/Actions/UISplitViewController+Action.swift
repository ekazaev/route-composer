//
// Created by Eugene Kazaev on 2018-09-18.
//

import Foundation
import UIKit

/// Actions for `UISplitViewController`
extension Container where Self.ViewController: UISplitViewController {

    /// Presents a view controller as a master in the `UISplitViewController`
    public static func setAsMaster() -> UISplitViewController.SetAsMasterAction<Self.ViewController> {
        return UISplitViewController.SetAsMasterAction()
    }

    /// Presents a view controller as a detail in the `UISplitViewController`
    public static func pushToDetails() -> UISplitViewController.PushToDetailsAction<Self.ViewController> {
        return UISplitViewController.PushToDetailsAction()
    }

}
