//
// Created by Kazaev, Eugene on 2019-02-15.
//

import Foundation

/// Returns key `UIWindow`
public struct KeyWindowProvider: WindowProvider {

    /// `UIWindow` instance
    public var window: UIWindow? {
        guard let window = UIApplication.shared.keyWindow else {
            assertionFailure("Application does not have a key window.")
            return nil
        }
        return window
    }

    /// Constructor
    public init() {
    }

}
