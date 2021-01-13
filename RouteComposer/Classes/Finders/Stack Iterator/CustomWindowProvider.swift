//
// RouteComposer
// CustomWindowProvider.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2021.
// Distributed under the MIT license.
//

#if os(iOS)

import Foundation
import UIKit

/// Returns custom `UIWindow`
public struct CustomWindowProvider: WindowProvider {

    // MARK: Properties

    /// Returns key `UIWindow`
    public weak var window: UIWindow?

    // MARK: Methods

    /// Constructor
    public init(window: UIWindow) {
        self.window = window
    }

}

#endif
