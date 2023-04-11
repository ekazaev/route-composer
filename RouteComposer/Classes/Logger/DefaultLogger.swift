//
// RouteComposer
// DefaultLogger.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import os.log

/// Default Logger implementation
public struct DefaultLogger: Logger {

    // MARK: Properties

    /// Log level
    public let logLevel: LogLevel

    private let osLog: OSLog

    // MARK: Methods

    /// Constructor.
    ///
    /// - Parameters:
    ///   - logLevel: DefaultLoggerLevel. Defaulted to warnings.
    ///   - osLog: OSLog instance of the app.
    public init(_ logLevel: LogLevel = .warnings,
                osLog: OSLog = OSLog.default) {
        self.logLevel = logLevel
        self.osLog = osLog
    }

    public func log(_ message: LogMessage) {
        switch message {
        case let .warning(message):
            if logLevel == .verbose || logLevel == .warnings {
                os_log("%@", log: osLog, type: .error, message)
            }
        case let .info(message):
            if logLevel == .verbose {
                os_log("%@", log: osLog, type: .info, message)
            }
        case let .error(message):
            os_log("%@", log: osLog, type: .fault, message)
        }
    }

}
