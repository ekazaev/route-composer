//
// RouteComposer
// InlineFactory.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2025.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import UIKit

/// The `Factory` that creates a `UIViewController` instance using build closure.
/// ### Usage
/// ```swift
/// let productScreen = StepAssembler<ProductViewController, ProductContext>()
///         .finder(.classWithContextFinder)
///         .factory(.build { ProductViewController(context: $0) })
///         .adding(ContextSettingTask())
///         .using(.push)
///         .from(.navigationController)
///         .using(.present)
///         .from(.current)
///         .assemble()
/// ```
/// Might be useful for the configuration testing.
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

// MARK: Shorthands

extension InlineFactory {
    /// Shorthand to be used as `.factory(.build(...))`
    public static func build(_ buildBlock: @escaping (Context) -> ViewController) -> InlineFactory {
        InlineFactory(buildBlock)
    }
}

extension StepAssemblerWithFinder {
    /// Shorthand to be used as `.factory(.build(...))`
    public func factory(_ factory: InlineFactory<F.ViewController, F.Context>) -> StepAssembly<F, InlineFactory<F.ViewController, F.Context>> {
        return getFactory(factory)
    }
}
