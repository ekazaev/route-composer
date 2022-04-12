//
// RouteComposer
// FactoryBox.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
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

    func build<Context>(with context: Context) throws -> UIViewController {
        guard let typedContext = Any?.some(context as Any) as? FactoryType.Context else {
            throw RoutingError.typeMismatch(type: type(of: context),
                                            expectedType: FactoryType.Context.self,
                                            .init("\(String(describing: factory.self)) does not accept \(String(describing: context.self)) as a context."))
        }
        assertIfNotMainThread()
        assertIfNotPrepared()
        return try factory.build(with: typedContext)
    }

}
