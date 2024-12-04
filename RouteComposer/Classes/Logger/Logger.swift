//
// RouteComposer
// Logger.swift
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

/// Routing logger protocol
public protocol Logger {

    // MARK: Methods to implement

    /// Logs a message
    ///
    /// - Parameters:
    ///  - message: The `LogMessage` instance
    func log(_ message: LogMessage)

}
