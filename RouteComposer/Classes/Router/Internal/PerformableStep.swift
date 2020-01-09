//
// Created by Eugene Kazaev on 20/02/2018.
//

#if os(iOS)

import Foundation

protocol PerformableStep {

    /// - Parameter context: The `Context` instance that `Router` has started with.
    /// - Returns: The `StepResult` enum value, which may contain a view controller in case of `.success` scenario.
    func perform<Context>(with context: Context) throws -> PerformableStepResult

}

#endif
