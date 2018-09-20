//
// Created by Eugene Kazaev on 2018-09-18.
//

import Foundation
import UIKit

/// Actions for UISplitViewController
extension Container where Self.ViewController: UISplitViewController {

    /// Presents a detail view controller in the `UISplitViewController`
    public static func setAsMaster() -> UISplitViewController.SetAsMasterAction<Self> {
        return UISplitViewController.SetAsMasterAction<Self>()
    }

    /// Presents a detail view controller in the `UISplitViewController`
    public static func pushToDetails() -> UISplitViewController.PushToDetailsAction<Self> {
        return UISplitViewController.PushToDetailsAction<Self>()
    }

}
