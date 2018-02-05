//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

/// Finder to be used by Router to find out if this UIViewController is in view cnotroller stack
public protocol DeepLinkFinder {

    /// Method to be extedned to implement Finder functionality.
    ///
    /// - Parameter arguments: Arduments passed to the router to be presented in a final destination.
    /// - Returns: UIViewController instance that Router is looking for if it has already been built in to
    ///   view controller stack, nil otherwise.
    func findViewController(with arguments: Any?) -> UIViewController?

}
