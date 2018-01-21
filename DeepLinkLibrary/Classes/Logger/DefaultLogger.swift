//
// Created by Eugene Kazaev on 19/01/2018.
//

import Foundation

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
                print("WARNING: \(message)")
            }
        case .info(let message):
            if logLevel == .verbose {
                print("INFO: \(message)")
            }
        case .error(let message):
            print("ERROR: \(message)")
        }
    }

}
