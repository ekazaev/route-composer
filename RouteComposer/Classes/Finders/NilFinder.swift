//
// RouteComposer
// NilFinder.swift
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

/// Dummy struct used to represent that nothing should be found in a view controller stack
/// and a `UIViewController` should always be created from scratch.
/// Its only purpose is to provide type safety checks for `StepAssembly`.
///
/// For example, `UIViewController` of this step was already loaded and integrated into a stack by a storyboard.
public struct NilFinder<VC: UIViewController, C>: Finder, NilEntity {

    // MARK: Associated types

    public typealias ViewController = VC

    public typealias Context = C

    // MARK: Methods

    /// Constructor
    public init() {}

    /// `Finder` method empty implementation.
    ///
    /// - Parameter context: A context instance provided.
    /// - Returns: always `nil`.
    public func findViewController(with context: C) throws -> VC? {
        nil
    }

}
