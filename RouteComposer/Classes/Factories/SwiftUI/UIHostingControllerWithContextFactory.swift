//
// RouteComposer
// UIHostingControllerWithContextFactory.swift
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

/// Builds `UIHostingController` with `ContentView` as a `UIHostingController.rootView` using the constructor
/// provided with `ContextInstantiatable` implementation.
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct UIHostingControllerWithContextFactory<ContentView: View & ContextInstantiatable>: Factory {

    // MARK: Associated types

    public typealias ViewController = UIHostingController<ContentView>

    public typealias Context = ContentView.Context

    // MARK: Methods

    /// Constructor
    public init() {}

    public func build(with context: Context) throws -> UIHostingController<ContentView> {
        let viewController = UIHostingController(rootView: ContentView(with: context))
        return viewController
    }

}

#endif
