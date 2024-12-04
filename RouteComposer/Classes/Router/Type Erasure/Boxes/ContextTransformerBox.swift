//
// RouteComposer
// ContextTransformerBox.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation

final class ContextTransformerBox<T: ContextTransformer>: AnyContextTransformer {

    let transformer: T

    init(_ transformer: T) {
        self.transformer = transformer
    }

    func transform<Context>(_ context: AnyContext) throws -> Context {
        let typedContext: T.SourceContext = try context.value()
        guard let transformedContext = try transformer.transform(typedContext) as? Context else {
            throw RoutingError.typeMismatch(type: type(of: T.TargetContext.self),
                                            expectedType: Context.self,
                                            .init("Failed to transform \(String(describing: T.TargetContext.self)) to \(String(describing: Context.self))."))
        }
        return transformedContext
    }

}
