//
// Created by Kazaev, Eugene on 2019-02-15.
//

#if os(iOS)

import Foundation
import UIKit

/// Returns key `UIWindow`
public struct KeyWindowProvider: WindowProvider {

    // MARK: Properties

    /// `UIWindow` instance
    public var window: UIWindow? {
        guard let window = UIApplication.shared.keyWindow else {
            assertionFailure("Application does not have a key window.")
            return nil
        }
        return window
    }

    // MARK: Methods

    /// Constructor
    public init() {
    }

}

#endif
