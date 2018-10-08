//
// Created by Eugene Kazaev on 19/12/2017.
// Copyright (c) 2017 HBC Tech. All rights reserved.
//

import Foundation

/// The result of the navigation process
///
/// - handled: The request to process the navigation resulted in a successful navigation to the destination.
/// - unhandled: The request to process the navigation was not handled.
public enum RoutingResult {

    /// The request to process the navigation resulted in a successful navigation to the destination.
    case handled

    /// The request to process the navigation was not handled.
    case unhandled(Error)

}

public extension RoutingResult {

    /// Returns `true` if `RoutingResult` is `.handled`
    public var isSuccessful: Bool {
        guard case .handled = self else {
            return false
        }
        return true
    }

}
