//
// RouteComposer
// DefaultLogger+LogLevel.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation

public extension DefaultLogger {

    /// Log level settings
    ///
    /// - verbose: Log all the messages from a `Router`
    /// - warnings: Log only warnings and errors
    /// - errors: Log only errors
    enum LogLevel: CaseIterable {

        /// Log all the messages from `Router`
        case verbose

        /// Log only warnings and errors
        case warnings

        /// Log only errors
        case errors

    }

}
