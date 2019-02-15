//
// Created by Eugene Kazaev on 2018-11-23.
//

import Foundation
import UIKit

/// Returns custom `UIWindow`
public struct CustomWindowProvider: WindowProvider {

    /// Returns key `UIWindow`
    public weak var window: UIWindow?

    /// Constructor
    public init(window: UIWindow) {
        self.window = window
    }

}
