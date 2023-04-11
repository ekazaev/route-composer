//
// RouteComposer
// ContextAccepting.swift
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

/// The protocol for a `UIViewController` to make it compatible with `ContextSettingTask`.
public protocol ContextAccepting where Self: UIViewController {

    // MARK: Associated types

    /// Type of `Context` object that `UIViewController` can deal with
    associatedtype Context

    // MARK: Methods to implement

    /// If `UIViewController` does not support all the permutations that context instance may have -
    /// setup the check here.
    ///
    /// - Parameter context: `Context` instance.
    /// - Throws: throws `Error` if `Context` instance is not supported.
    static func checkCompatibility(with context: Context) throws

    /// `ContextSettingTask` will call this method to provide the `Context` instance to the `UIViewController`
    /// that has just been build or found.
    ///
    /// - Parameter context: `Context` instance.
    /// - Throws: throws `Error` if `Context` instance is not supported. `Router` will stop building the rest of the stack in this case.
    func setup(with context: Context) throws

}

// MARK: Default implementation

public extension ContextAccepting {

    /// Default implementation does nothing.
    static func checkCompatibility(with context: Context) throws {}

}
