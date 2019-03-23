//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright © 2018 HBC Digital. All rights reserved.
//

import Foundation
import UIKit

/// A default implementation of the view controllers finder that searches for a view controller by its name.
public struct ClassFinder<VC: UIViewController, C>: StackIteratingFinder {

    /// A `StackIterator` is to be used by `ClassFinder`
    public let iterator: StackIterator

    /// Constructor
    ///
    /// - Parameter iterator: A `StackIterator` is to be used by `ClassFinder`
    public init(iterator: StackIterator = DefaultStackIterator()) {
        self.iterator = iterator
    }

    public func isTarget(_ viewController: VC, with context: C) -> Bool {
        return true
    }

}

/// Extension to use `DefaultStackIterator` as default iterator.
public extension ClassFinder {

    /// Constructor
    ///
    /// Parameters
    ///   - options: A combination of the `SearchOptions`
    ///   - startingPoint: `DefaultStackIterator.StartingPoint` value
    init(options: SearchOptions, startingPoint: DefaultStackIterator.StartingPoint = .topmost) {
        self.iterator = DefaultStackIterator(options: options, startingPoint: startingPoint)
    }

}
