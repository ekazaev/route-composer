//
// Created by Eugene Kazaev on 19/01/2018.
//

import Foundation
import os.log

public enum DefaultLoggerLevel {

    case verbose

    case warnings

    case errors

}

public class DefaultLogger: Logger {

    private let logLevel: DefaultLoggerLevel

    public init(_ logLevel: DefaultLoggerLevel = .warnings) {
        self.logLevel = logLevel
    }

    public func log(_ message: LoggerMessage) {
        switch message {
        case .warning(let message):
            if logLevel == .verbose || logLevel == .warnings {
                if #available(iOS 10, *) {
                    os_log("%@", log: OSLog.default, type: .error, message)
                } else {
                    print("WARNING: \(message)")
                }
            }
        case .info(let message):
            if logLevel == .verbose {
                if #available(iOS 10, *) {
                    os_log("%@", log: OSLog.default, type: .info, message)
                } else {
                    print("INFO: \(message)")
                }
            }
        case .error(let message):
            if #available(iOS 10, *) {
                os_log("%@", log: OSLog.default, type: .fault, message)
            } else {
                print("ERROR: \(message)")
            }
        }
    }

}
