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

extension Array where Element: UIViewController {

    var nonDismissibleViewController: UIViewController? {
        return compactMap {
            $0 as? RoutingInterceptable & UIViewController
        }.first {
            !$0.canBeDismissed
        }
    }

    func uniqueElements() -> [Element] {
        var buffer = [Element]()
        var added = Set<Element>()
        for element in self {
            if !added.contains(element) {
                buffer.append(element)
                added.insert(element)
            }
        }
        return buffer
    }

}
