//
// RouteComposer
// KeyWindowProvider.swift
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

/// Returns key `UIWindow`
@MainActor
public struct KeyWindowProvider: WindowProvider {

    // MARK: Properties

    /// `UIWindow` instance
    public var window: UIWindow? {
        let keyWindow: UIWindow? = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: { $0.isKeyWindow })

        guard let window = keyWindow else {
            assertionFailure("Application does not have a key window.")
            return nil
        }
        return window
    }

    // MARK: Methods

    /// Constructor
    public nonisolated init() {}

}
