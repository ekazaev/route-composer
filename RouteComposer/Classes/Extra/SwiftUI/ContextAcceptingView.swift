//
// RouteComposer
// ContextAcceptingView.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

#if canImport(SwiftUI)

import Foundation
import SwiftUI
import UIKit

/// The protocol for a `View` to make it compatible with `ContextSettingTask`.
///
/// *Due to some current `swift` limitations protocol `ContextAccepting` can not be used directly.*
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public protocol ContextAcceptingView {

    // MARK: Associated types

    /// Type of `Context` object that `View` can be accept
    associatedtype Context

    // MARK: Methods to implement

    /// If `View` does not support all the permutations that context instance may have -
    /// setup the check here.
    ///
    /// - Parameter context: `Context` instance.
    /// - Throws: throws `Error` if `Context` instance is not supported.
    static func checkCompatibility(with context: Context) throws

    /// `ContextSettingTask` will call this method to provide the `Context` instance to the `View`
    /// that has just been build or found.
    ///
    /// - Parameter context: `Context` instance.
    /// - Throws: throws `Error` if `Context` instance is not supported. `Router` will stop building the rest of the stack in this case.
    mutating func setup(with context: Context) throws

}

// MARK: Default implementation

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public extension ContextAcceptingView {

    /// Default implementation does nothing.
    static func checkCompatibility(with context: Context) throws {}

}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension UIHostingController: ContextAccepting where Content: ContextAcceptingView {

    public static func checkCompatibility(with context: Content.Context) throws {
        try Content.checkCompatibility(with: context)
    }

    public func setup(with context: Content.Context) throws {
        try rootView.setup(with: context)
    }

}

#endif
