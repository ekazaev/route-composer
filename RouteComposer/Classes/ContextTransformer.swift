//
// RouteComposer
// ContextTransformer.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
//

import Foundation

/// Transformer to be applied to transform one type of context to another.
public protocol ContextTransformer {

    // MARK: Associated types

    /// Type of source context
    associatedtype SourceContext

    /// Type of target context
    associatedtype TargetContext

    // MARK: Methods to implement

    /// Transforms one value into another.
    /// - Parameter context: Source content of type `SourceContext`
    /// - Returns: converted context of type `TargetContext`
    /// - Throws: The `Error` if `SourceContext` can not be converted to `TargetContext`.
    func transform(_ context: SourceContext) throws -> TargetContext

}

protocol AnyContextTransformer {

    func transform<Context>(_ context: AnyContext) throws -> Context

}

struct EmptyAnyContextTransformer: AnyContextTransformer {
    func transform<Context>(_ context: AnyContext) throws -> Context {
        let transformedContext = try context.value() as Context
        return transformedContext
    }
}

struct InplaceAnyContext: AnyContext {
    let context: AnyContext
    let transformer: AnyContextTransformer

    init(context: AnyContext, transformer: AnyContextTransformer) {
        self.context = context
        self.transformer = transformer
    }

    func value<Context>() throws -> Context {
        return try transformer.transform(context)
    }
}

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

public struct NilContextTransformer<Context>: ContextTransformer {
    public func transform(_ context: Context) throws -> Context {
        return context
    }
}
