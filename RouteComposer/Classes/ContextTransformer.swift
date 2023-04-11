//
// RouteComposer
// ContextTransformer.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
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
