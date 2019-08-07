//
// Created by Eugene Kazaev on 01/03/2018.
//

import Foundation
import UIKit

/// - Extension of an `Array` of the `UIViewControllers` is to check if all of them can be dismissed.
public extension Array where Element: UIViewController {

    /// Returns `true` if all `UIViewController` instances can be dismissed.
    var canBeDismissed: Bool {
        return nonDismissibleViewController == nil
    }

}
