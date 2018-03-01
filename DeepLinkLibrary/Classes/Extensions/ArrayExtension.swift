//
// Created by Eugene Kazaev on 01/03/2018.
//

import Foundation
import UIKit

/// - Extension to Array of UIViewControllers to check if all of them can be dismissed.
public extension Array where Element: UIViewController {

    var canBeDismissed: Bool {
        get {
            return self.nonDismissableViewController == nil
        }
    }

}

internal extension Array where Element: UIViewController {

    var nonDismissableViewController: UIViewController? {
        get {
            return self.flatMap {
                $0 as? RouterRulesSupport & UIViewController
            }.first {
                !$0.canBeDismissed
            }
        }
    }

}
