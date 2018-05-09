//
// Created by Eugene Kazaev on 19/12/2017.
// Copyright (c) 2017 Gilt Groupe. All rights reserved.
//

import Foundation

/// The result of the Routing process
///
/// - handled: The request to process the deep link resulted in a successful navigation to the destination.
/// - unhandled: The request to process the deep link was not handled and therefore did not result in any navigation.
public enum RoutingResult {

    /// The request to process the deep link resulted in a successful navigation to the destination.
    case handled

    /// The request to process the deep link was not handled and therefore did not result in any navigation.
    case unhandled

}
