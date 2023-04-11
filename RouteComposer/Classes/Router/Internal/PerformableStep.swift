//
// RouteComposer
// PerformableStep.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation

protocol PerformableStep {

    /// - Parameter context: The `Context` instance that `Router` has started with.
    /// - Returns: The `StepResult` enum value, which may contain a view controller in case of `.success` scenario.
    func perform(with context: AnyContext) throws -> PerformableStepResult

}
