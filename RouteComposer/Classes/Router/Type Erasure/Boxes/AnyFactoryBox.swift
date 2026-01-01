//
// RouteComposer
// AnyFactoryBox.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2026.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation

@MainActor
protocol AnyFactoryBox: AnyFactory {

    associatedtype FactoryType: AbstractFactory

    var factory: FactoryType { get set }

    init?(_ factory: FactoryType, action: AnyAction)

}

@MainActor
protocol PreparableAnyFactory: AnyFactory, PreparableEntity {

    var isPrepared: Bool { get set }

}

@MainActor
extension AnyFactoryBox {

    mutating func scrapeChildren(from factories: [(factory: AnyFactory, context: AnyContext)]) throws -> [(factory: AnyFactory, context: AnyContext)] {
        factories
    }

}

@MainActor
extension AnyFactoryBox where Self: PreparableAnyFactory {

    mutating func prepare(with context: AnyContext) throws {
        let typedContext: FactoryType.Context = try context.value()
        try factory.prepare(with: typedContext)
        isPrepared = true
    }

}

@MainActor
extension AnyFactory where Self: CustomStringConvertible & AnyFactoryBox {

    var description: String {
        String(describing: factory)
    }

}
