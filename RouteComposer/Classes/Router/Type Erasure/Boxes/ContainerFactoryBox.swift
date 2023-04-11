//
// RouteComposer
// ContainerFactoryBox.swift
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

struct ContainerFactoryBox<F: ContainerFactory>: PreparableAnyFactory, AnyFactoryBox, MainThreadChecking, CustomStringConvertible {

    typealias FactoryType = F

    var factory: FactoryType

    let action: AnyAction

    var children: [(factory: PostponedIntegrationFactory, context: AnyContext)] = []

    var isPrepared = false

    init?(_ factory: FactoryType, action: AnyAction) {
        guard !(factory is NilEntity) else {
            return nil
        }
        self.factory = factory
        self.action = action
    }

    mutating func scrapeChildren(from factories: [(factory: AnyFactory, context: AnyContext)]) throws -> [(factory: AnyFactory, context: AnyContext)] {
        var otherFactories: [(factory: AnyFactory, context: AnyContext)] = []
        var isNonEmbeddableFound = false
        children = factories.compactMap { child -> (factory: PostponedIntegrationFactory, context: AnyContext)? in
            guard !isNonEmbeddableFound, child.factory.action.isEmbeddable(to: FactoryType.ViewController.self) else {
                otherFactories.append(child)
                isNonEmbeddableFound = true
                return nil
            }
            return (factory: PostponedIntegrationFactory(for: child.factory), context: child.context)
        }
        return otherFactories
    }

    func build(with context: AnyContext) throws -> UIViewController {
        let typedContext: FactoryType.Context = try context.value()
        assertIfNotMainThread()
        assertIfNotPrepared()
        return try factory.build(with: typedContext, integrating: ChildCoordinator(childFactories: children))
    }

}
