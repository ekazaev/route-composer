//
//  DefaultLogger.swift
//  RouteComposer
//
//  Created by Eugene Kazaev on 08/02/2018.
//

import Foundation
import os.log

/// Default Logger implementation
public struct DefaultLogger: Logger {

    /// Log level
    public let logLevel: LogLevel

    private let osLog: OSLog?

    /// Constructor
    ///
    /// - Parameter logLevel: DefaultLoggerLevel. Defaulted to warnings.
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
