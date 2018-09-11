//
// Created by Eugene Kazaev on 07/09/2018.
//

import Foundation

/// Assembly that extends this protocol should be able to connect an action to its step.
public protocol ActionConnecting {

    associatedtype Context

    /// Connects previously provided `RoutingStep` instance with an `Action`
    ///
    /// - Parameter action: `Action` instance to be used with a step.
    /// - Returns: `ChainAssembly` to continue building the chain.
    func using<A: Action>(_ action: A) -> StepChainAssembly<Context>

    /// Connects previously provided `RoutingStep` instance with an `Action`
    ///
    /// - Parameter action: `Action` instance to be used with a step.
    /// - Returns: `ChainAssembly` to continue building the chain.
    func using<A: ContainerAction>(_ action: A) -> StepChainAssembly<Context>

}
