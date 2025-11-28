//
// RouteComposer
// StepAssembler.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2025.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
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
/// *Introduced by  [Savva Shuliatev](https://github.com/Savva-Shuliatev) *
public struct BuildFactory<ViewController: UIViewController, Context>: Factory {

    public typealias ViewController = ViewController

    public typealias Context = Context

    private let buildBlock: (Context) -> ViewController

    public init(_ buildBlock: @escaping (Context) -> ViewController) {
        self.buildBlock = buildBlock
    }

    public func build(with context: Context) throws -> ViewController {
        buildBlock(context)
    }

}

// MARK: Shorthands

extension BuildFactory {
    /// Shorthand to be used as `.factory(.build(...))`
    public static func build(_ buildBlock: @escaping (Context) -> ViewController) -> BuildFactory {
        BuildFactory(buildBlock)
    }
}

extension StepAssemblerWithFinder {
    /// Shorthand to be used as `.factory(.build(...))`
    public func factory(_ factory: BuildFactory<F.ViewController, F.Context>) -> StepAssembly<F, BuildFactory<F.ViewController, F.Context>> {
        return getFactory(factory)
    }
}
