//
// Created by Eugene Kazaev on 19/12/2017.
// Copyright (c) 2017 HBC Tech. All rights reserved.
//

import Foundation

/// The result of the navigation process
///
/// - success: The request to process the navigation resulted in a successful navigation to the destination.
/// - failure: The request to process the navigation was not successful.
public enum RoutingResult {

    /// The request to process the navigation resulted in a successful navigation to the destination.
    case success

    /// The request to process the navigation was not successful.
    case failure(Error)

}

public extension RoutingResult {

    /// Returns `true` if `RoutingResult` is `success`
    var isSuccessful: Bool {
        guard case .success = self else {
            return false
        }
        return true
    }

}
