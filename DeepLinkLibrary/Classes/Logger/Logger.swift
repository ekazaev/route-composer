//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

public enum LoggerMessage {

    case info(String)

    case warning(String)

    case error(String)

}

public protocol Logger {

    func routingWillStart()

    func log(_ message: LoggerMessage)

    func routingDidFinish()

}

public extension Logger {

    func routingWillStart() {
    }

    func routingDidFinish() {
    }

}