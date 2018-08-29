//
// Created by Eugene Kazaev on 01/03/2018.
//

import Foundation
import UIKit

/// - Extension to Array of UIViewControllers to check if all of them can be dismissed.
public extension Array where Element: UIViewController {

    /// Returns `true` if all `UIViewController` instances can be dismissed.
    var canBeDismissed: Bool {
        return self.nonDismissibleViewController == nil
    }

}

internal extension Array where Element: UIViewController {

    var nonDismissibleViewController: UIViewController? {
        return self.compactMap {
            $0 as? RoutingInterceptable & UIViewController
        }.first {
            !$0.canBeDismissed
        }
    }

    func uniqElements() -> [Element] {
        var buffer = [Element]()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }

}
