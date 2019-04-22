//
//  FinderFactory.swift
//  RouteComposer
//
//  Created by Eugene Kazaev on 08/02/2018.
//

import Foundation
import UIKit

/// The `CompleteFactory` instance is used by the `CompleteFactoryAssembly` as a `ContainerFactory` to
/// pre-populate the children view controllers instead of the `Router`.
public struct CompleteFactory<FC: ContainerFactory>: ContainerFactory, CustomStringConvertible {

    public typealias ViewController = FC.ViewController

    public typealias Context = FC.Context

    private var factory: FC

    var childFactories: [PostponedIntegrationFactory<FC.Context>]

    init(factory: FC, childFactories: [PostponedIntegrationFactory<FC.Context>]) {
        self.factory = factory
        self.childFactories = childFactories
    }

    mutating public func prepare(with context: FC.Context) throws {
        try factory.prepare(with: context)
        childFactories = try childFactories.map({
            var factory = $0
            try factory.prepare(with: context)
            return factory
        })
    }

    public func build(with context: FC.Context, integrating coordinator: ChildCoordinator<FC.Context>) throws -> FC.ViewController {
        var finalChildFactories = childFactories
        finalChildFactories.append(contentsOf: coordinator.childFactories)
        return try factory.build(with: context, integrating: ChildCoordinator(childFactories: finalChildFactories))
    }

    public var description: String {
        return String(describing: factory)
    }

}
