//
// RouteComposer
// UIHostingControllerFactory.swift
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

/// Builds `UIHostingController` with `ContentView` as a `UIHostingController.rootView` using the provided block.
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct UIHostingControllerFactory<ContentView: View, Context>: Factory {

    // MARK: Associated types

    public typealias ViewController = UIHostingController<ContentView>

    public typealias Context = Context

    // MARK: Properties

    private let buildBlock: (Context) -> ContentView

    // MARK: Methods

    /// Constructor
    /// - Parameter buildBlock: Block that builds the `View` with the using the `Context` instance provided.
    public init(_ buildBlock: @escaping (Context) -> ContentView) {
        self.buildBlock = buildBlock
    }

    public func build(with context: Context) throws -> UIHostingController<ContentView> {
        let viewController = UIHostingController(rootView: buildBlock(context))
        return viewController
    }

}

#endif
