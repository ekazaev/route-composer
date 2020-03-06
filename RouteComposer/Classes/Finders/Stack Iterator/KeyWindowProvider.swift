//
// RouteComposer
// KeyWindowProvider.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2020.
// Distributed under the MIT license.
//

#if os(iOS)

import Foundation
import UIKit

/// Returns key `UIWindow`
public struct KeyWindowProvider: WindowProvider {

    // MARK: Properties

    /// `UIWindow` instance
    public var window: UIWindow? {
        guard let window = UIApplication.shared.keyWindow else {
            assertionFailure("Application does not have a key window.")
            return nil
        }
        return window
    }

    // MARK: Methods

    /// Constructor
    public init() {}

}

#endif
