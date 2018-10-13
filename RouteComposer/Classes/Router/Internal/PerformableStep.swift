//
// Created by Eugene Kazaev on 20/02/2018.
//

import Foundation

protocol PerformableStep {

    /// - Parameter context: The `Context` instance that `Router` has started with.
    /// - Returns: The `StepResult` enum value, which may contain a view controller in case of `.success` scenario.
    func perform(with context: Any?) throws -> StepResult

}

protocol FinderFactoryStep: PerformableStep {

    var factory: AnyFactory? { get }

    var finder: AnyFinder? { get }

}

extension FinderFactoryStep {

    func perform(with context: Any?) throws -> StepResult {
        guard let viewController = try finder?.findViewController(with: context) else {
            return .continueRouting(factory)
        }
        return .success(viewController)
    }

}
