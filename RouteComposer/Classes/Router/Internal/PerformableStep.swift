//
// RouteComposer
// PerformableStep.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2020.
// Distributed under the MIT license.
//

#if os(iOS)

import Foundation

protocol PerformableStep {

    /// - Parameter context: The `Context` instance that `Router` has started with.
    /// - Returns: The `StepResult` enum value, which may contain a view controller in case of `.success` scenario.
    func perform<Context>(with context: Context) throws -> PerformableStepResult

}

#endif
