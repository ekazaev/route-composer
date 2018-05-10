//
// Created by Eugene Kazaev on 26/02/2018.
//

import Foundation

/// Routing Error representation
///
/// - message: Message describing error that happened
public enum RoutingError: Error {

    ///  Message describing error that happened
    case message(String)

}
