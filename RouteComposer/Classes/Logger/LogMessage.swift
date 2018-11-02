//
// Created by Eugene Kazaev on 2018-11-02.
//

import Foundation

/// `Logger` message representation
///
/// - `info`: info message
/// - `warning`: warning message
/// - `error`: error message
public enum LogMessage {

    /// info message
    case info(String)

    /// warning message
    case warning(String)

    /// error message
    case error(String)

}
