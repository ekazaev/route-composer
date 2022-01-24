//
// RouteComposer
// Logger.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
//

#if os(iOS)

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

#endif
