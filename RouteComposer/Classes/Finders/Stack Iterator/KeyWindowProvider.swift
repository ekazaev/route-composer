//
// RouteComposer
// KeyWindowProvider.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2024.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import UIKit

/// Returns key `UIWindow`
public struct KeyWindowProvider: WindowProvider {

    // MARK: Properties

    /// `UIWindow` instance
    public var window: UIWindow? {
        let keyWindow: UIWindow? = if #available(iOS 13, *) {
            UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            UIApplication.shared.keyWindow
        }
        guard let window = keyWindow else {
            assertionFailure("Application does not have a key window.")
            return nil
        }
        return window
    }

    // MARK: Methods

    /// Constructor
    public init() {}

}
