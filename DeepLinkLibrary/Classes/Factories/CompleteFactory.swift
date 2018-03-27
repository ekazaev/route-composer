//
//  FinderFactory.swift
//  DeepLinkLibrary
//
//  Created by Eugene Kazaev on 08/02/2018.
//

import Foundation
import UIKit

/// `CompleteFactoryAssembly` uses this container factory wrapper to substitute provided factory and allow you to
/// preset child factories instead of `Router`.
public class CompleteFactory<FC: Factory & Container>: Factory, Container {

    public typealias ViewController = FC.ViewController

    public typealias Context = FC.Context

    public let action: Action

    let factory: FC

    let childFactories: [ChildFactory<FC.Context>]

    private var mergedOnce = false

    init(factory: FC, childFactories: [ChildFactory<FC.Context>]) {
        self.factory = factory
        self.action = factory.action
        self.childFactories = childFactories
    }

    public func prepare(with context: Context) throws {
        try factory.prepare(with: context)
    }

    public func merge<C>(_ factories: [ChildFactory<C>]) -> [ChildFactory<C>] {
        mergedOnce = true
        guard var childFactories = childFactories as? [ChildFactory<C>] else {
            return factory.merge(factories)
        }
        childFactories.append(contentsOf: factories)
        return factory.merge(childFactories)
    }

    public func build(with context: Context) throws -> ViewController {
        if !mergedOnce {
            let oddFactories = factory.merge(childFactories)
            guard oddFactories.count == 0 else {
                throw RoutingError.message("Some factories can not be successfully integrated in to \(String(describing: factory)). Check action settings of child factories.")
            }
        }
        return try factory.build(with: context)
    }

}
