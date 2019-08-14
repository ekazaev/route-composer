//
// Created by Eugene Kazaev on 07/09/2018.
//

import Foundation
import UIKit

/// An assembly that conforms to this protocol should be able to connect an action to its step.
public protocol ActionConnecting {

    // MARK: Associated types

    /// Associated type of the `UIViewController`
    associatedtype ViewController: UIViewController

    /// Associated type of the `Context`
    associatedtype Context

    // MARK: Methods to implement

    /// Connects previously provided step instance with an `Action`
    ///
    /// - Parameter action: `Action` instance to be used with a step.
    /// - Returns: `ChainAssembly` to continue building the chain.
    func using<A: Action>(_ action: A) -> StepChainAssembly<ViewController, Context>

    /// Connects previously provided step instance with an `Action`
    ///
    /// - Parameter action: `Action` instance to be used with a step.
    /// - Returns: `ChainAssembly` to continue building the chain.
    func using<A: ContainerAction>(_ action: A) -> ContainerStepChainAssembly<A.ViewController, ViewController, Context>

}
