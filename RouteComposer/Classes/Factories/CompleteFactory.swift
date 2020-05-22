//
// RouteComposer
// CompleteFactory.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2020.
// Distributed under the MIT license.
//

#if os(iOS)

import Foundation
import UIKit

/// The `CompleteFactory` instance is used by the `CompleteFactoryAssembly` as a `ContainerFactory` to
/// pre-populate the children view controllers instead of the `Router`.
public struct CompleteFactory<FC: ContainerFactory>: ContainerFactory, CustomStringConvertible {

    // MARK: Associated types

    public typealias ViewController = FC.ViewController

    public typealias Context = FC.Context

    // MARK: Properties

    private var factory: FC

    var childFactories: [PostponedIntegrationFactory<FC.Context>]

    // MARK: Methods

    init(factory: FC, childFactories: [PostponedIntegrationFactory<FC.Context>]) {
        self.factory = factory
        self.childFactories = childFactories
    }

    public mutating func prepare(with context: FC.Context) throws {
        try factory.prepare(with: context)
        childFactories = try childFactories.map {
            var factory = $0
            try factory.prepare(with: context)
            return factory
        }
    }

    public func build(with context: FC.Context, integrating coordinator: ChildCoordinator<FC.Context>) throws -> FC.ViewController {
        var finalChildFactories = childFactories
        finalChildFactories.append(contentsOf: coordinator.childFactories)
        return try factory.build(with: context, integrating: ChildCoordinator(childFactories: finalChildFactories))
    }

    public var description: String {
        String(describing: factory)
    }

}

#endif
