//
// Created by Eugene Kazaev on 2018-11-23.
//

import Foundation
import UIKit

/// Provides `UIWindow`
public protocol WindowProvider {

    // MARK: Methods to implement

    /// `UIWindow` instance
    var window: UIWindow? { get }

}
