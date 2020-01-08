//
// Created by Eugene Kazaev on 15/01/2018.
//

#if os(iOS)

import Foundation
import UIKit

/// Routing logger protocol
public protocol Logger {

    // MARK: Methods to implement

    /// Logs a message
    ///
    /// - Parameters:
    ///  - message: The `LogMessage` instance
    func log(_ message: LogMessage)

}

#endif
