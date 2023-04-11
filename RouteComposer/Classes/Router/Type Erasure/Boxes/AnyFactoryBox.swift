//
// RouteComposer
// AnyFactoryBox.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation

protocol AnyFactoryBox: AnyFactory {

    associatedtype FactoryType: AbstractFactory

    var factory: FactoryType { get set }

    init?(_ factory: FactoryType, action: AnyAction)

}

protocol PreparableAnyFactory: AnyFactory, PreparableEntity {

    var isPrepared: Bool { get set }

}

extension AnyFactoryBox {

    mutating func scrapeChildren(from factories: [(factory: AnyFactory, context: AnyContext)]) throws -> [(factory: AnyFactory, context: AnyContext)] {
        factories
    }

}

extension AnyFactoryBox where Self: PreparableAnyFactory, Self: MainThreadChecking {

    mutating func prepare(with context: AnyContext) throws {
        assertIfNotMainThread()
        let typedContext: FactoryType.Context = try context.value()
        try factory.prepare(with: typedContext)
        isPrepared = true
    }

}

extension AnyFactory where Self: CustomStringConvertible & AnyFactoryBox {

    var description: String {
        String(describing: factory)
    }

}
