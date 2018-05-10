//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit

/// `Finder` to be used by `Router` to find out if this `UIViewController` instance is in view controller stack
public protocol Finder {

    /// Type of `UIViewController` that `Finder` can find
    associatedtype ViewController: UIViewController

    /// Type of `Context` object that `Finder` can deal with
    associatedtype Context

    /// The  method to be extended to implement `Finder` functionality.
    ///
    /// - Parameter context: The `Context` instance passed to the `Router` to be presented in a final destination.
    /// - Returns: The `UIViewController` instance that `Router` is looking for if it is already built into
    ///   the view controller stack, nil otherwise.
    func findViewController(with context: Context) -> ViewController?

}
