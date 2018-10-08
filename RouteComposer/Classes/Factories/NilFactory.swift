//
//  NilFactory.swift
//  RouteComposer
//
//  Created by Eugene Kazaev on 08/02/2018.
//

import Foundation
import UIKit

/// The dummy struct used to represent the `Factory` that does not build anything.
/// Its only purpose is to provide the type safety checks for the `StepAssembly`.
///
/// For example, the `UIViewController` of the step was already loaded and integrated into a stack by a
/// storyboard in a previous step.
public struct NilFactory<VC: UIViewController, C>: Factory, NilEntity {

    public typealias ViewController = VC

    public typealias Context = C

    /// Constructor
    public init() {
    }

    public func build(with context: Context) throws -> ViewController {
        throw RoutingError.message("This factory should never reach the router.")
    }

}
