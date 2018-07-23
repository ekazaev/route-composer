//
//  FinderFactory.swift
//  RouteComposer
//
//  Created by Eugene Kazaev on 08/02/2018.
//

import Foundation
import UIKit

/// `CompleteFactory` is used by the `CompleteFactoryAssembly` as a `Container` `Factory` to allow you to
/// populate child factories instead of `Router`.
public struct CompleteFactory<FC: Factory & Container>: Factory, Container, CustomStringConvertible {

    public typealias ViewController = FC.ViewController

    public typealias Context = FC.Context

    public let action: Action
    
    private var factory: FC
    
    let childFactories: [ChildFactory<FC.Context>]

    init(factory: FC, childFactories: [ChildFactory<FC.Context>]) {
        self.factory = factory
        self.action = factory.action
        self.childFactories = childFactories
    }

    public func prepare(with context: Context) throws {
        try factory.prepare(with: context)
    }

    mutating public func merge<C>(_ factories: [ChildFactory<C>]) -> [ChildFactory<C>] {
        guard var childFactories = childFactories as? [ChildFactory<C>] else {
            return factory.merge(factories)
        }
        childFactories.append(contentsOf: factories)
        return factory.merge(childFactories)
    }

    public func build(with context: Context) throws -> ViewController {
        return try factory.build(with: context)
    }

    public var description: String {
        return String(describing: factory)
    }

}
