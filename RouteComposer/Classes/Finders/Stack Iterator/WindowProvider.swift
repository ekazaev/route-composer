//
// RouteComposer
// WindowProvider.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
//

#if os(iOS)

import Foundation
import UIKit

/// Provides `UIWindow`
public protocol WindowProvider {

    // MARK: Properties to implement

    /// `UIWindow` instance
    var window: UIWindow? { get }

}

#endif
