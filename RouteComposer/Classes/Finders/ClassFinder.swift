//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit

/// A default implementation of the unique view controller finder, where view controller can be found by name.
/// (Example: Home, account, log in, etc supposed to be in the view stack just once)
public class ClassFinder<VC:UIViewController, C>: StackIteratingFinder {

    /// `UIViewController` type associated with this `ClassFinder`
    public typealias ViewController = VC

    /// The context type associated with this `ClassFinder`
    public typealias Context = C

    /// `SearchOptions` to be used by `ClassFinder`
    public let options: SearchOptions

    /// Constructor
    ///
    /// - Parameter options: A combination of the `SearchOptions`
    public init(options: SearchOptions = .currentAndUp) {
        self.options = options
    }

    public func isTarget(_ viewController: ViewController, with context: Context) -> Bool {
        return true
    }

}
