//
// Created by Kazaev, Eugene on 2019-02-15.
//

import Foundation

/// Returns key `UIWindow`
public struct KeyWindowProvider: WindowProvider {

    /// `UIWindow` instance
    public var window: UIWindow? {
        return UIApplication.shared.keyWindow
    }

    /// Constructor
    public init() {
    }

}
