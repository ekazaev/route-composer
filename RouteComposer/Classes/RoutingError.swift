//
// Created by Eugene Kazaev on 26/02/2018.
//

import Foundation

/// Routing `Error` representation
///
/// - message: Message describing an error that happened
public enum RoutingError: Error {

    /// Error context holder
    public struct Context {

        ///  Message describing error that happened
        public let debugDescription: String

        /// Underlying error if present
        public let underlyingError: Error?

        /// Constructor
        public init(debugDescription: String, underlyingError: Error? = nil) {
            self.debugDescription = debugDescription
            self.underlyingError = underlyingError
        }

    }

    /// Type mismatch error
    case typeMismatch(Any.Type, RoutingError.Context)

    /// The view controllers stack build failed
    case compositionFailed(RoutingError.Context)

    ///  Message describing error that happened
    case generic(RoutingError.Context)

}
