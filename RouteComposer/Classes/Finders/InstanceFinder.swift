//
// Created by Eugene Kazaev on 15/01/2018.
//

#if os(iOS)

import Foundation
import UIKit

/// The `Finder` that provides the `Router` a known instance of the `UIViewController`
public struct InstanceFinder<VC: UIViewController, C>: Finder {

    // MARK: Associated types

    public typealias ViewController = VC

    public typealias Context = C

    // MARK: Properties

    /// The `UIViewController` instance that `Finder` will provide to the `Router`
    private(set) public weak var instance: VC?

    // MARK: Methods

    /// Constructor
    ///
    /// - Parameters:
    ///   - instance: The `UIViewController` instance that `Finder` should provide to the `Router`
    public init(instance: VC) {
        self.instance = instance
    }

    public func findViewController(with context: C) throws -> VC? {
        return instance
    }

}

#endif
