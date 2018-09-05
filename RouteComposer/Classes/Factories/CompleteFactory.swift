//
//  FinderFactory.swift
//  RouteComposer
//
//  Created by Eugene Kazaev on 08/02/2018.
//

import Foundation
import UIKit

/// The `CompleteFactory` instance is used by the `CompleteFactoryAssembly` as a `Container` to
/// pre-populate the `ChildFactories` instead of the `Router`.
public struct CompleteFactory<FC: Container>: Container, CustomStringConvertible {

    public typealias ViewController = FC.ViewController

    public typealias Context = FC.Context

    public typealias SupportedAction = FC.SupportedAction

    private var factory: FC

    let childFactories: [ChildFactory<FC.Context>]

    init(factory: FC, childFactories: [ChildFactory<FC.Context>]) {
        self.factory = factory
        self.childFactories = childFactories
    }

    mutating public func prepare(with context: Context) throws {
        try factory.prepare(with: context)
    }

    public func build(with context: Context, integrating factories: [ChildFactory<Context>]) throws -> ViewController {
        var childFactories = self.childFactories
        childFactories.append(contentsOf: factories)
        return try factory.build(with: context, integrating: childFactories)
    }

    public var description: String {
        return String(describing: factory)
    }

}
