//
//  FinderFactory.swift
//  RouteComposer
//
//  Created by Eugene Kazaev on 08/02/2018.
//

import Foundation
import UIKit

/// The `StepAssembly` transforms a `Finder` result as a `Factory` result. It is useful
/// when a `UIViewController` instance was built inside of the parent `ContainerFactory`.
public struct FinderFactory<F: Finder>: Factory {

    private let finder: F

    public typealias ViewController = F.ViewController

    public typealias Context = F.Context

    /// Constructor
    ///
    /// - Parameters:
    ///   - finder: The `Finder` instance to be used by the `Factory`
    public init?(finder: F) {
        guard !(finder is NilEntity) else {
            return nil
        }
        self.finder = finder
    }

    public func build(with context: F.Context) throws -> F.ViewController {
        guard let viewController = try finder.findViewController(with: context) else {
            throw RoutingError.compositionFailed(.init("\(String(describing: finder)) hasn't found its view controller in the stack."))
        }
        return viewController
    }

}
