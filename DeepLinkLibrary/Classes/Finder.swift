//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

/// `Finder` to be used by `Router` to find out if this `UIViewController` instance is in view controller stack
public protocol Finder {

    /// Type of UIViewController that Finder can find
    associatedtype ViewController: UIViewController

    /// Type of Context object that finder can deal with
    associatedtype Context

    /// Method to be extended to implement Finder functionality.
    ///
    /// - Parameter context: Context object passed to the `Router` to be presented in a final destination.
    /// - Returns: `UIViewController` instance that `Router` is looking for if it has already been built in to
    ///   view controller stack, nil otherwise.
    func findViewController(with context: Context) -> ViewController?

}
