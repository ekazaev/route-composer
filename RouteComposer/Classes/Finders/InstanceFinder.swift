//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright © 2018 HBC Digital. All rights reserved.
//

import Foundation
import UIKit

/// The `Finder` that provides the `Router` a known instance of the `UIViewController`
public struct InstanceFinder<VC: UIViewController, C>: Finder {

    /// The `UIViewController` type associated with this `InstanceFinder`
    public typealias ViewController = VC

    /// The context type associated with this `InstanceFinder`
    public typealias Context = C

    /// The `UIViewController` instance that `Finder` will provide to the `Router`
    private(set) public weak var instance: VC?

    /// Constructor
    ///
    /// - Parameters:
    ///   - instance: The `UIViewController` instance that `Finder` should provide to the `Router`
    public init(instance: VC) {
        self.instance = instance
    }

    public func findViewController(with context: Context) -> ViewController? {
        return instance
    }

}
