//
// Created by Eugene Kazaev on 26/02/2018.
//

import Foundation

/// Routing `Error` representation
///
/// - message: Message describing an error that happened
public enum RoutingError: Error, CustomStringConvertible {

    /// Error context holder
    public struct Context: CustomStringConvertible {

        ///  Message describing error that happened
        public let debugDescription: String

        /// Underlying error if present
        public let underlyingError: Error?

        /// Constructor
        public init(_ debugDescription: String, underlyingError: Error? = nil) {
            self.debugDescription = debugDescription
            self.underlyingError = underlyingError
        }

        public var description: String {
            guard debugDescription.isEmpty else {
                return debugDescription
            }

            guard let underlyingError = underlyingError else {
                return "No valuable information provided"
            }

            return (underlyingError as CustomStringConvertible).description
        }

    }

    /// Type mismatch error
    case typeMismatch(Any.Type, RoutingError.Context)

    /// The view controllers stack integration failed
    case compositionFailed(RoutingError.Context)

    /// Message describing error that happened
    case generic(RoutingError.Context)

    public var description: String {
        switch self {
        case .typeMismatch(_, let context):
            return "Type Mismatch Error: \(context.description)"
        case .compositionFailed(let context):
            return "Composition Failed Error: \(context.description)"
        case .generic(let context):
            return "Generic Error: \(context.description)"
        }
    }

}
