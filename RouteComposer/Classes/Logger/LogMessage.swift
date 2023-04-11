//
// RouteComposer
// LogMessage.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation

/// `Logger` message representation
///
/// - `info`: info message
/// - `warning`: warning message
/// - `error`: error message
public enum LogMessage {

    /// info message
    case info(String)

    /// warning message
    case warning(String)

    /// error message
    case error(String)

}
