//
// Created by Eugene Kazaev on 31/08/2018.
//

import Foundation

/// Protocol to implement `Action` connections for tha assemblies.
public protocol Usable {

    /// Connects previously provided `RoutingStep` instance with an `Action`
    ///
    /// - Parameter action: `Action` instance to be used with a step.
    /// - Returns: `ChainAssembly` to continue building the chain.
    func using(_ action: Action) -> ChainAssembly

}
