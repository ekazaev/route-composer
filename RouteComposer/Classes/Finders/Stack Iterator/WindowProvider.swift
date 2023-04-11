//
// RouteComposer
// WindowProvider.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import UIKit

/// Provides `UIWindow`
public protocol WindowProvider {

    // MARK: Properties to implement

    /// `UIWindow` instance
    var window: UIWindow? { get }

}
