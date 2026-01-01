//
// RouteComposer
// FactoryBox.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2026.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import UIKit

@MainActor
struct FactoryBox<F: Factory>: PreparableAnyFactory, AnyFactoryBox, @preconcurrency CustomStringConvertible {

    typealias FactoryType = F

    var factory: F

    let action: AnyAction

    var isPrepared = false

    init?(_ factory: F, action: AnyAction) {
        guard !(factory is NilEntity) else {
            return nil
        }
        self.factory = factory
        self.action = action
    }

    func build(with context: AnyContext) throws -> UIViewController {
        let typedContext: FactoryType.Context = try context.value()
        assertIfNotPrepared()
        return try factory.build(with: typedContext)
    }

}
