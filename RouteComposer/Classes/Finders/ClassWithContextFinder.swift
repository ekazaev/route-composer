//
// Created by Eugene Kazaev on 27/02/2018.
//

import Foundation
import UIKit

/// A default implementation of the view controllers finder, that searches for a view controller by its name
/// and its `Context` instance.
///
/// The view controller should conform to the `ContextChecking` to be used with this finder.
public struct ClassWithContextFinder<VC: ContextChecking, C>: StackIteratingFinder where VC.Context == C {

    /// A `StackIterator` is to be used by `ClassWithContextFinder`
    public let iterator: StackIterator

    /// Constructor
    ///
    /// - Parameter iterator: A `StackIterator` is to be used by `ClassWithContextFinder`
    public init(iterator: StackIterator = DefaultStackIterator()) {
        self.iterator = iterator
    }

    public func isTarget(_ viewController: VC, with context: C) -> Bool {
        return viewController.isTarget(for: context)
    }

}

/// Extension to use `DefaultStackIterator` as default iterator.
public extension ClassWithContextFinder {

    /// Constructor
    ///
    /// Parameters
    ///   - options: A combination of the `SearchOptions`
    ///   - startingPoint: `DefaultStackIterator.StartingPoint` value
    ///   - containerAdapterProvider: A `ContainerAdapterProvider` instance.
    init(options: SearchOptions,
         startingPoint: DefaultStackIterator.StartingPoint = .topmost,
         containerAdapterProvider: ContainerAdapterProvider = ContainerAdapterRegistry.shared) {
        self.iterator = DefaultStackIterator(options: options, startingPoint: startingPoint, containerAdapterProvider: containerAdapterProvider)
    }

}
