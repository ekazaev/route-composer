//
// RouteComposer
// InlineContextTransformer.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation

/// `InlineContextTransformer`
///
/// **NB:** It may be used for the purpose of configuration testing, but then replaced with a strongly typed
/// `ContextTransformer` instance.
public final class InlineContextTransformer<SourceContext, TargetContext>: ContextTransformer {

    // MARK: Properties

    private let transformationBlock: (SourceContext) throws -> TargetContext

    // MARK: Methods

    /// Constructor
    ///
    /// - Parameter transformationBlock: the block to be called when it requested to transform the context.
    public init(_ transformationBlock: @escaping (SourceContext) throws -> TargetContext) {
        self.transformationBlock = transformationBlock
    }

    public func transform(_ context: SourceContext) throws -> TargetContext {
        return try transformationBlock(context)
    }
}
