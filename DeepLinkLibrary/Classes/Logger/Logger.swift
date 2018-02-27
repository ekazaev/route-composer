//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

/// Logger message representation
///
/// - info: info message
/// - warning: warning message
/// - error: error message
public enum LoggerMessage {

    case info(String)

    case warning(String)

    case error(String)

}

/// Routing logger protocol
public protocol Logger {

    /// Will be called by the Router when routing process starts
    func routingWillStart()

    /// Will be called by the Router to log LoggerMessage instance
    ///
    /// - Parameter message: LoggerMessage instance
    func log(_ message: LoggerMessage)

    /// Will be called by the Router when routing process finishes
    func routingDidFinish()

}

public extension Logger {

    func routingWillStart() {
    }

    func routingDidFinish() {
    }

}
