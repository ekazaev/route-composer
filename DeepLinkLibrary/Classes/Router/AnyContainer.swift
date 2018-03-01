//
// Created by Eugene Kazaev on 22/02/2018.
//

import Foundation
import UIKit

/// Non typesafe boxing wrapper for Container protocol
public protocol AnyContainer {

    /// Receives an array of factories whose view controllers should be merged into current container
    /// factory before it actually builds a container view controller with child view controllers inside.
    ///
    /// - Parameter factories: Array of factories to be handled by container factory.
    /// - Returns: Array of factories that are not supported by this container type. Router should decide how to deal with them.
    func merge(_ factories: [AnyFactory]) -> [AnyFactory]

}
