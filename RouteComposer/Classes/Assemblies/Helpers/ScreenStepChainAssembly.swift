//
// Created by Eugene Kazaev on 31/08/2018.
//

import Foundation

/// Helper class to build a chain of steps. Can not be used directly.
public struct ScreenStepChainAssembly: Usable {

    let previousSteps: [RoutingStep]

    init(previousSteps: [RoutingStep]) {
        self.previousSteps = previousSteps
    }

    public func using(_ action: Action) -> ChainAssembly {
        return ChainAssembly(previousSteps: previousSteps)
    }
}
