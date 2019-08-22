//
// Created by Eugene Kazaev on 15/01/2018.
//

import Foundation
import UIKit

/// A default implementation of the view controllers finder that searches for a view controller by its name.
public struct ClassFinder<VC: UIViewController, C>: StackIteratingFinder {

    // MARK: Associated types

    public typealias ViewController = VC

    public typealias Context = C

    // MARK: Properties

    /// A `StackIterator` is to be used by `ClassFinder`
    public let iterator: StackIterator

    // MARK: Methods

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
    ///   - containerAdapterLocator: A `ContainerAdapterLocator` instance.
    init(options: SearchOptions,
         startingPoint: DefaultStackIterator.StartingPoint = .topmost,
         containerAdapterLocator: ContainerAdapterLocator = DefaultContainerAdapterLocator()) {
        iterator = DefaultStackIterator(options: options, startingPoint: startingPoint, containerAdapterLocator: containerAdapterLocator)
    }

}
