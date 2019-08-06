//
// Created by Eugene Kazaev on 2019-08-06.
//

import UIKit
import Foundation

/// `Finder` that helps to find the `UINavigationController` inside of the details of the `UISplitController`
public struct DetailsNavigationFinder<C>: Finder {

    public typealias ViewController = UINavigationController

    public typealias Context = C

    /// A `StackIterator` is to be used by `ClassFinder`
    public let iterator: StackIterator

    /// Constructor
    ///
    /// - Parameter iterator: A `StackIterator` is to be used by `ClassFinder`
    public init(iterator: StackIterator = DefaultStackIterator()) {
        self.iterator = iterator
    }

    public func findViewController(with context: Context) throws -> ViewController? {
        guard let splitViewController = try ClassFinder<UISplitViewController, Context>(iterator: iterator).findViewController(with: context) else {
            return nil
        }
        guard splitViewController.viewControllers.count > 1 else {
            guard let firstNavigationController = splitViewController.viewControllers.first as? UINavigationController,
                  let secondNavigationController = firstNavigationController.viewControllers.last as? UINavigationController else {
                return nil
            }
            return secondNavigationController
        }
        return splitViewController.viewControllers.last as? UINavigationController
    }

}

/// Extension to use `DefaultStackIterator` as default iterator.
public extension DetailsNavigationFinder {

    /// Constructor
    ///
    /// Parameters
    ///   - options: A combination of the `SearchOptions`
    ///   - startingPoint: `DefaultStackIterator.StartingPoint` value
    ///   - containerAdapterLocator: A `ContainerAdapterLocator` instance.
    init(options: SearchOptions,
         startingPoint: DefaultStackIterator.StartingPoint = .topmost,
         containerAdapterLocator: ContainerAdapterLocator = DefaultContainerAdapterLocator()) {
        let iterator = DefaultStackIterator(options: options,
                startingPoint: startingPoint,
                containerAdapterLocator: containerAdapterLocator)
        self.init(iterator: iterator)
    }

}
