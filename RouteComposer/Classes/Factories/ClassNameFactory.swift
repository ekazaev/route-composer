//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright © 2018 HBC Digital. All rights reserved.
//

import UIKit

/// The `Factory` that creates a `UIViewController` class by its name
public struct ClassNameFactory<VC: UIViewController, C>: Factory {

    /// The name of a `UIViewController` class to be built by the `Factory`
    public let viewControllerName: String?

    /// Constructor
    ///
    /// - Parameters:
    ///   - viewControllerName: The name of a `UIViewController` class to be built, if not provided - `ViewController`
    ///     type will be used.
    public init(viewControllerName: String? = nil) {
        self.viewControllerName = viewControllerName
    }

    public func build(with context: C) throws -> VC {
        if let viewControllerName = viewControllerName {
            guard let customClass = NSClassFromString(viewControllerName) else {
                throw RoutingError.compositionFailed(RoutingError.Context("Can not find \(viewControllerName) in the bundle."))
            }
            guard let customViewControllerClass = customClass as? VC.Type else {
                throw RoutingError.typeMismatch(customClass.self, RoutingError.Context("\(viewControllerName) is not an " +
                        "expected UIViewController type class."))
            }

            return customViewControllerClass.init(nibName: nil, bundle: nil)
        } else {
            return ViewController(nibName: nil, bundle: nil)
        }
    }

}
