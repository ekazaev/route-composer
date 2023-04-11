//
// RouteComposer
// Destination.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import UIKit

/// `AnyDestination` represents a generic `Destination` that contains the screen configuration  for any type
/// of `UIViewController` and the context of any type.
public typealias AnyDestination = Destination<UIViewController, Any?>

/// `Destination` instance represents both final screen configuration and the data to provide. It is useful when
/// there is a need to wrap both values into a single DTO value.
public struct Destination<VC: UIViewController, C> {

    // MARK: Properties

    /// Final configuration.
    public let step: DestinationStep<VC, C>

    /// Data to be provided to the configuration.
    public let context: C

    // MARK: Methods

    /// Constructor
    ///
    /// - Parameters:
    ///   - step: `DestinationStep` instance containing the navigation configuration.
    ///   - context: `Context` instance to be provided to the configuration.
    public init(to step: DestinationStep<VC, C>, with context: C) {
        self.step = step
        self.context = context
    }

    /// Transforms into generic representation without information about types.
    public func unwrapped() -> AnyDestination {
        AnyDestination(to: step.unsafelyRewrapped(), with: context)
    }

}

// MARK: Helper methods where the Context is Any?

public extension Destination where C == Any? {

    /// Constructor
    ///
    /// - Parameters:
    ///   - step: `DestinationStep` instance containing the navigation configuration.
    init(to step: DestinationStep<VC, C>) {
        self.step = step
        self.context = nil
    }

}

// MARK: Helper methods where the Context is Void

public extension Destination where C == Void {

    /// Constructor
    ///
    /// - Parameters:
    ///   - step: `DestinationStep` instance containing the navigation configuration.
    init(to step: DestinationStep<VC, C>) {
        self.step = step
        self.context = ()
    }

}
