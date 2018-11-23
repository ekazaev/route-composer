//
// Created by Eugene Kazaev on 2018-11-23.
//

import Foundation
import UIKit

/// Returns key `UIWindow`
public struct DefaultWindowProvider: WindowProvider {

    public let window: UIWindow?

    /// Constructor
    public init(window: UIWindow? = UIApplication.shared.keyWindow) {
        self.window = window
    }

}
