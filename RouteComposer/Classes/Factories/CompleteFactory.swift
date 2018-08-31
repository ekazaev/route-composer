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
public struct CompleteFactory<FC: Container>: Container, CustomStringConvertible {

    public typealias ViewController = FC.ViewController

    public typealias Context = FC.Context

    private var factory: FC

    let childFactories: [ChildFactory<FC.Context>]

    init(factory: FC, childFactories: [ChildFactory<FC.Context>]) {
        self.factory = factory
        self.childFactories = childFactories
    }

    mutating public func prepare(with context: Context) throws {
        try factory.prepare(with: context)
    }

    mutating public func merge(_ factories: [ChildFactory<Context>]) -> [ChildFactory<Context>] {
        var childFactories = self.childFactories
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
