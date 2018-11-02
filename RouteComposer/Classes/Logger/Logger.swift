//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit

/// Routing logger protocol
public protocol Logger {

    /// Logs a message
    ///
    /// - Parameter message: The `LogMessage` instance
    func log(_ message: LogMessage)

}
