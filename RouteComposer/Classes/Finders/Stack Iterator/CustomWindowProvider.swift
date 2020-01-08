//
// Created by Eugene Kazaev on 2018-11-23.
//

#if os(iOS)

import Foundation
import UIKit

/// Returns custom `UIWindow`
public struct CustomWindowProvider: WindowProvider {

    // MARK: Properties

    /// Returns key `UIWindow`
    public weak var window: UIWindow?

    // MARK: Methods

    /// Constructor
    public init(window: UIWindow) {
        self.window = window
    }

}

#endif
