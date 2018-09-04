//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit

/// The `Finder` the provides to the `Router` a known instance of the `UIViewController`
public struct InstanceFinder<VC: UIViewController, C>: Finder {

    /// The `UIViewController` type associated with this `InstanceFinder`
    public typealias ViewController = VC

    /// The context type associated with this `InstanceFinder`
    public typealias Context = C

    private(set) weak var instance: VC?

    /// Constructor
    ///
    /// - Parameters:
    ///   - instance: The `UIViewController` instance this `Finder` should provide to the `Router`
    public init(instance: VC) {
        self.instance = instance
    }

    public func findViewController(with context: Context) -> ViewController? {
        return instance
    }

}
