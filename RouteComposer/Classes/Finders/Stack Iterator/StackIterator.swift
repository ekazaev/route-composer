//
// Created by Eugene Kazaev on 2018-11-07.
//

#if os(iOS)

import Foundation
import UIKit

/// `StackIterator` protocol
public protocol StackIterator {

    // MARK: Methods to implement

    /// Returns `UIViewController` instance if found
    ///
    /// - Parameter predicate: A block that contains `UIViewController` matching condition
    func firstViewController(where predicate: (UIViewController) -> Bool) throws -> UIViewController?

}

#endif
