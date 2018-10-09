//
//  FinderFactory.swift
//  RouteComposer
//
//  Created by Eugene Kazaev on 08/02/2018.
//

import Foundation
import UIKit

/// The `StepAssembly` transforms a `Finder` result as a `Factory` result. It is useful
/// when a `UIViewController` instance was built inside of the parent `Container`.
public struct FinderFactory<F: Finder>: Factory {

    public typealias ViewController = F.ViewController

    public typealias Context = F.Context

    private let finder: F

    /// Constructor
    ///
    /// - Parameters:
    ///   - finder: The `Finder` instance to be used by the `Factory`
    public init(finder: F) {
        self.finder = finder
    }

    public func build(with context: Context) throws -> ViewController {
        guard let viewController = finder.findViewController(with: context) else {
            throw RoutingError.compositionFailed(RoutingError.Context(debugDescription: "\(String(describing: finder)) hasn't found its view controller in the stack."))
        }
        return viewController
    }

}
