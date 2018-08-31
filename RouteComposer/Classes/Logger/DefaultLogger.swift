//
//  DefaultLogger.swift
//  RouteComposer
//
//  Created by Eugene Kazaev on 08/02/2018.
//

import Foundation
import os.log

/// Default Logger levels settings
///
/// - verbose: Log all the messages from a `Router`
/// - warnings: Log only warnings and errors
/// - errors: Log only errors
public enum DefaultLoggerLevel {

    /// Log all the messages from `Router`
    case verbose

    /// Log only warnings and errors
    case warnings

    /// Log only errors
    case errors

}

/// Default Logger implementation
public struct DefaultLogger: Logger {

    private let logLevel: DefaultLoggerLevel

    private let osLog: OSLog?

    /// Constructor
    ///
    /// - Parameter logLevel: DefaultLoggerLevel. Defaulted to warnings.
    public init(_ logLevel: DefaultLoggerLevel = .warnings) {
        self.logLevel = logLevel
        if #available(iOS 10.0, *) {
            self.osLog = OSLog.default
        } else {
            self.osLog = nil
        }
    }

    /// Constructor available in iOS 10 and later.
    ///
    /// - Parameters:
    ///   - logLevel: DefaultLoggerLevel. Defaulted to warnings.
    ///   - osLog: OSLog instance of the app.
    @available(iOS 10, *)
    public init(_ logLevel: DefaultLoggerLevel = .warnings, osLog: OSLog = OSLog.default) {
        self.logLevel = logLevel
        self.osLog = osLog
    }

    public func log(_ message: LoggerMessage) {
        switch message {
        case .warning(let message):
            if logLevel == .verbose || logLevel == .warnings {
                if #available(iOS 10, *) {
                    os_log("%@", log: self.osLog ?? OSLog.default, type: .error, message)
                } else {
                    NSLog("WARNING: \(message)")
                }
            }
        case .info(let message):
            if logLevel == .verbose {
                if #available(iOS 10, *) {
                    os_log("%@", log: self.osLog ?? OSLog.default, type: .info, message)
                } else {
                    NSLog("INFO: \(message)")
                }
            }
        case .error(let message):
            if #available(iOS 10, *) {
                os_log("%@", log: self.osLog ?? OSLog.default, type: .fault, message)
            } else {
                NSLog("ERROR: \(message)")
            }
        }
    }

}
