//
// RouteComposer
// CompleteFactory.swift
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

/// The `CompleteFactory` instance is used by the `CompleteFactoryAssembly` as a `ContainerFactory` to
/// pre-populate the children view controllers instead of the `Router`.
public struct CompleteFactory<FC: ContainerFactory>: ContainerFactory, CustomStringConvertible {

    // MARK: Associated types

    public typealias ViewController = FC.ViewController

    public typealias Context = FC.Context

    // MARK: Properties

    private var factory: FC

    var childFactories: [PostponedIntegrationFactory]

    // MARK: Methods

    init(factory: FC, childFactories: [PostponedIntegrationFactory]) {
        self.factory = factory
        self.childFactories = childFactories
    }

    public mutating func prepare(with context: FC.Context) throws {
        try factory.prepare(with: context)
        childFactories = try childFactories.map {
            var factory = $0
            try factory.prepare(with: AnyContextBox(context))
            return factory
        }
    }

    public func build(with context: FC.Context, integrating coordinator: ChildCoordinator) throws -> FC.ViewController {
        var finalChildFactories: [(factory: PostponedIntegrationFactory, context: AnyContext)] = childFactories.map { (factory: $0, context: AnyContextBox(context)) }
        finalChildFactories.append(contentsOf: coordinator.childFactories)
        return try factory.build(with: context, integrating: ChildCoordinator(childFactories: finalChildFactories))
    }

    public var description: String {
        String(describing: factory)
    }

}
