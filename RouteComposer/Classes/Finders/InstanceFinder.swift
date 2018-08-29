//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit

/// If, by the time of this `Finder` instantiation, `UIViewController` instance it should provide to
/// the `Router` is known and exists - use this finder.
public struct InstanceFinder<VC: UIViewController, C>: Finder {

    /// `UIViewController` type associated with this `InstanceFinder`
    public typealias ViewController = VC

    /// The context type associated with this `InstanceFinder`
    public typealias Context = C

    private weak var instance: VC?

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
