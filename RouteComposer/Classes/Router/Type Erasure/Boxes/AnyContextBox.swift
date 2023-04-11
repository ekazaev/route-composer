//
// RouteComposer
// AnyContextBox.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation

struct AnyContextBox<C>: AnyContext {
    let context: C

    init(_ context: C) {
        self.context = context
    }

    func value<Context>() throws -> Context {
        guard let typedContext = context as? Context else {
            throw RoutingError.typeMismatch(type: type(of: context),
                                            expectedType: Context.self,
                                            .init("\(String(describing: context.self)) can not be converted to \(String(describing: Context.self))."))
        }
        return typedContext
    }
}
