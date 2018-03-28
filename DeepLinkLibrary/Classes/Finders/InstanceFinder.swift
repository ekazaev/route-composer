//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

/// If, by the time of this `Finder` instantiation, `UIViewController` instance it should provide to
/// the `Router` is known and exists - use this finder.
public class InstanceFinder<VC:UIViewController, C>: Finder {

    public typealias ViewController = VC

    public typealias Context = C

    public weak var instance: VC?

    /// Constructor
    ///
    /// - Parameters:
    ///   - instance: `UIViewController` instance this `Finder` should provide to the `Router`
    public init(instance: VC) {
        self.instance = instance
    }

    public func findViewController(with context: Context) -> ViewController? {
        return instance
    }

}

