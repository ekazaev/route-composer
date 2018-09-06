//
// Created by Eugene Kazaev on 31/08/2018.
//

import Foundation

/// Helper class to build a chain of steps. Can not be used directly.
public struct LastStepInChainAssembly {

    let previousSteps: [RoutingStep]

    init(previousSteps: [RoutingStep]) {
        self.previousSteps = previousSteps
    }

    /// Assembles all the provided settings.
    ///
    /// - Returns: The instance of `RoutingStep` with all the settings provided inside.
    public func assemble() -> RoutingStep {
        return chain(previousSteps)
    }
}
