//
// Created by Eugene Kazaev on 26/02/2018.
//

import Foundation

/// Routing `Error` representation
///
/// - message: Message describing an error that happened
public enum RoutingError: Error, CustomStringConvertible {

    // MARK: Data

    /// Describes an error happened to the initial view controller
    public enum InitialControllerErrorState: CustomStringConvertible {

        /// View controller not found
        case notFound

        /// View controller deallocated
        case deallocated

        public var description: String {
            switch self {
            case .deallocated:
                return "Initial controller deallocated"
            case .notFound:
                return "Initial controller not found"
            }
        }
    }

    /// Error context holder
    public struct Context: CustomStringConvertible {

        /// Message describing error that happened
        public let debugDescription: String

        /// Underlying error if present
        public let underlyingError: Error?

        /// Constructor
        public init(_ debugDescription: String, underlyingError: Error? = nil) {
            self.debugDescription = debugDescription
            self.underlyingError = underlyingError
        }

        public var description: String {
            let errorDescription: String?
            if let underlyingError = underlyingError {
                errorDescription = "\(underlyingError)"
            } else {
                errorDescription = nil
            }
            let descriptionParts = [!debugDescription.isEmpty ? debugDescription : nil, errorDescription].compactMap({ $0 })
            guard descriptionParts.isEmpty else {
                return descriptionParts.joined(separator: " -> ")
            }

            return "No valuable information provided"
        }

    }

    // MARK: Error types

    /// Type mismatch error
    case typeMismatch(type: Any.Type, expectedType: Any.Type, RoutingError.Context)

    /// The view controllers stack integration failed
    case compositionFailed(RoutingError.Context)

    /// Initial view controller error
    case initialController(InitialControllerErrorState, RoutingError.Context)

    /// Message describing error that happened
    case generic(RoutingError.Context)

    // MARK: Helper methods

    public var description: String {
        switch self {
        case .typeMismatch(let type, let expectedType, let context):
            return "Type Mismatch Error: Type \(String(describing: type)) is not equal to the expected type \(String(describing: expectedType)). " +
                    "\(context.description)"
        case .compositionFailed(let context):
            return "Composition Failed Error: \(context.description)"
        case .initialController(let state, let context):
            return "Initial Controller Error: \(state). \(context.description)"
        case .generic(let context):
            return "Generic Error: \(context.description)"
        }
    }

}
