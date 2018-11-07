//
// Created by Eugene Kazaev on 2018-11-07.
//

import Foundation
import UIKit

/// `StackIterator` protocol
public protocol StackIterator {

    /// Returns `UIViewController` instance if found
    ///
    /// - Parameter comparator: A block that contains `UIViewController` matching condition
    func findViewController(using comparator: (UIViewController) -> Bool) -> UIViewController?

}
