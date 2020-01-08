//
// Created by Eugene Kazaev on 05/09/2018.
//

#if os(iOS)

import Foundation

public extension DefaultLogger {

    /// Log level settings
    ///
    /// - verbose: Log all the messages from a `Router`
    /// - warnings: Log only warnings and errors
    /// - errors: Log only errors
    enum LogLevel: CaseIterable {

        /// Log all the messages from `Router`
        case verbose

        /// Log only warnings and errors
        case warnings

        /// Log only errors
        case errors

    }

}

#endif
