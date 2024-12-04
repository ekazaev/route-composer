//
// RouteComposer
// FinderFactory.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import UIKit

/// The `StepAssembly` transforms a `Finder` result as a `Factory` result. It is useful
/// when a `UIViewController` instance was built inside of the parent `ContainerFactory`.
public struct FinderFactory<F: Finder>: Factory {

    // MARK: Associated types

    public typealias ViewController = F.ViewController

    public typealias Context = F.Context

    // MARK: Properties

    /// The additional configuration block
    public let configuration: ((_: F.ViewController) -> Void)?

    private let finder: F

    // MARK: Methods

    /// Constructor
    ///
    /// - Parameters:
    ///   - finder: The `Finder` instance to be used by the `Factory`
    public init?(finder: F, configuration: ((_: F.ViewController) -> Void)? = nil) {
        guard !(finder is NilEntity) else {
            return nil
        }
        self.finder = finder
        self.configuration = configuration
    }

    public func build(with context: F.Context) throws -> F.ViewController {
        guard let viewController = try finder.findViewController(with: context) else {
            throw RoutingError.compositionFailed(.init("\(String(describing: finder)) hasn't found its view controller in the stack."))
        }
        if let configuration {
            configuration(viewController)
        }
        return viewController
    }

}
