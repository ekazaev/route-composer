//
// Created by Eugene Kazaev on 19/12/2017.
// Copyright (c) 2017 HBC Tech. All rights reserved.
//

import Foundation

/// The result of the Routing process
///
/// - handled: The request to process the routing resulted in a successful navigation to the destination.
/// - unhandled: The request to process the routing was not handled and therefore did not result in any navigation.
public enum RoutingResult {

    /// The request to process the routing resulted in a successful navigation to the destination.
    case handled

    /// The request to process the routing was not handled and therefore did not result in any navigation.
    case unhandled

}

public extension RoutingResult {

    /// Returns `true` if `RoutingResult` is `.handled`
    public var isSuccessful: Bool {
        return self == .handled
    }

}
