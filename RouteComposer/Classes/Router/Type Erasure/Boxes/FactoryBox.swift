//
// RouteComposer
// FactoryBox.swift
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

struct FactoryBox<F: Factory>: PreparableAnyFactory, AnyFactoryBox, MainThreadChecking, CustomStringConvertible {

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
        assertIfNotMainThread()
        assertIfNotPrepared()
        return try factory.build(with: typedContext)
    }

}
