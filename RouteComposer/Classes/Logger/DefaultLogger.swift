//
// RouteComposer
// DefaultLogger.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2021.
// Distributed under the MIT license.
//

#if os(iOS)

import Foundation
import os.log

/// Default Logger implementation
public struct DefaultLogger: Logger {

    // MARK: Properties

    /// Log level
    public let logLevel: LogLevel

    private let osLog: OSLog?

    // MARK: Methods

    /// Constructor
    ///
    /// - Parameters:
    ///  - logLevel: DefaultLoggerLevel. Defaulted to warnings.
    public init(_ logLevel: LogLevel = .warnings) {
        self.logLevel = logLevel
        if #available(iOS 10.0, *) {
            self.osLog = OSLog.default
        } else {
            self.osLog = nil
        }
    }

    /// Constructor is available in iOS 10 and later.
    ///
    /// - Parameters:
    ///   - logLevel: DefaultLoggerLevel. Defaulted to warnings.
    ///   - osLog: OSLog instance of the app.
    @available(iOS 10, *)
    public init(_ logLevel: LogLevel = .warnings, osLog: OSLog = OSLog.default) {
        self.logLevel = logLevel
        self.osLog = osLog
    }

    public func log(_ message: LogMessage) {
        switch message {
        case let .warning(message):
            if logLevel == .verbose || logLevel == .warnings {
                if #available(iOS 10, *) {
                    os_log("%@", log: osLog ?? OSLog.default, type: .error, message)
                } else {
                    NSLog("WARNING: \(message)")
                }
            }
        case let .info(message):
            if logLevel == .verbose {
                if #available(iOS 10, *) {
                    os_log("%@", log: osLog ?? OSLog.default, type: .info, message)
                } else {
                    NSLog("INFO: \(message)")
                }
            }
        case let .error(message):
            if #available(iOS 10, *) {
                os_log("%@", log: osLog ?? OSLog.default, type: .fault, message)
            } else {
                NSLog("ERROR: \(message)")
            }
        }
    }

}

#endif
