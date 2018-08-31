//
//  FinderFactory.swift
//  RouteComposer
//
//  Created by Eugene Kazaev on 08/02/2018.
//

import Foundation
import UIKit

/// `StepAssembly` uses `Finder` result as a `Factory` result. Used with things that do not have actual
/// factories like `UIViewController`s that were built as a result of storyboard loading.
public struct FinderFactory<F: Finder>: Factory {

    public typealias ViewController = F.ViewController

    public typealias Context = F.Context

    let finder: F

    /// Constructor
    ///
    /// - Parameters:
    ///   - finder: The `Finder` instance to be used by `Factory`
    public init(finder: F) {
        self.finder = finder
    }

    public func build(with context: Context) throws -> ViewController {
        if let viewController = finder.findViewController(with: context) {
            return viewController
        }
        throw RoutingError.message("Finder \(String(describing: finder)) not found its view controller in stack.")
    }

}
