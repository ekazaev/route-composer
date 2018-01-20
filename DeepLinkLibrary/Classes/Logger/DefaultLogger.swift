//
// Created by Eugene Kazaev on 19/01/2018.
//

import Foundation

public class DefaultLogger: Logger {

    public init() {

    }

    public func log(_ message: LoggerMessage) {
        switch message {
        case .warning(let message):
            print("WARNING: \(message)")
        case .info(let message):
            print("INFO: \(message)")
        case .error(let message):
            print("ERROR: \(message)")
        }
    }

}
