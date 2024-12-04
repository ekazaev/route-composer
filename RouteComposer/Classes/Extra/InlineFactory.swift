//
// RouteComposer
// InlineFactory.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import UIKit

/// `InlineFactory`. Might be useful for the configuration testing.
public struct InlineFactory<VC: UIViewController, C>: Factory {

    // MARK: Associated types

    /// Type of `UIViewController` that `Factory` can build
    public typealias ViewController = VC

    /// `Context` to be passed into `UIViewController`
    public typealias Context = C

    // MARK: Properties

    let inlineBock: (C) throws -> VC

    // MARK: Functions

    /// Constructor
    /// - Parameter inlineBock: the block to be called when `InlineFactory.build(...)` is requested.
    public init(viewController inlineBock: @autoclosure @escaping () throws -> VC) {
        self.inlineBock = { _ in
            try inlineBock()
        }
    }

    /// Constructor
    /// - Parameter inlineBock: the block to be called when `InlineFactory.build(...)` is requested.
    public init(_ inlineBock: @escaping (C) throws -> VC) {
        self.inlineBock = inlineBock
    }

    public func build(with context: C) throws -> VC {
        return try inlineBock(context)
    }

}
