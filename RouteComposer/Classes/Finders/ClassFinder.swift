//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit

/// A default implementation of the view controller finder, that searches for a view controller by its name.
/// (Example: Home, Account, log in, etc supposed to be in the view stack just once)
public struct ClassFinder<VC: UIViewController, C>: StackIteratingFinder {

    /// A `UIViewController` type associated with this `ClassFinder`
    public typealias ViewController = VC

    /// A context type associated with this `ClassFinder`
    public typealias Context = C

    /// A `SearchOptions` to be used by `ClassFinder`
    public let options: SearchOptions

    /// Constructor
    ///
    /// - Parameter options: A combination of the `SearchOptions`
    public init(options: SearchOptions = .currentAndDown) {
        self.options = options
    }

    public func isTarget(_ viewController: ViewController, with context: Context) -> Bool {
        return true
    }

}
