//
// Created by Eugene Kazaev on 2018-11-07.
//

import Foundation
import UIKit

/// `StackIterator` protocol
public protocol StackIterator {

    /// Returns `UIViewController` instance if found
    ///
    /// - Parameter predicate: A block that contains `UIViewController` matching condition
    func firstViewController(where predicate: (UIViewController) -> Bool) throws -> UIViewController?

}
