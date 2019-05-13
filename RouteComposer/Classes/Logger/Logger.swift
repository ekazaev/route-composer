//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright © 2018 HBC Digital. All rights reserved.
//

import Foundation
import UIKit

/// Routing logger protocol
public protocol Logger {

    /// Logs a message
    ///
    /// - Parameters:
    ///  - message: The `LogMessage` instance
    func log(_ message: LogMessage)

}
