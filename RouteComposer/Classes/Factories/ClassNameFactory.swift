//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright © 2018 HBC Digital. All rights reserved.
//

import UIKit

/// The `Factory` that creates a `UIViewController` class by its name
public struct ClassNameFactory<VC: UIViewController, C>: Factory {

    /// The name of a `UIViewController` class to be built by the `Factory`
    public let viewControllerName: String?

    /// A Xib file name
    public let nibName: String?

    /// A `Bundle` instance
    public let bundle: Bundle?

    /// Constructor
    ///
    /// - Parameters:
    ///   - viewControllerName: The name of a `UIViewController` class to be built, if not provided - `ViewController`
    ///     type will be used.
    ///   - nibName: A Xib file name
    ///   - bundle: A `Bundle` instance if needed
    public init(viewControllerName: String? = nil, nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        self.viewControllerName = viewControllerName
        self.nibName = nibNameOrNil
        self.bundle = nibBundleOrNil
    }

    public func build(with context: C) throws -> VC {
        if let viewControllerName = viewControllerName {
            guard let customClass = NSClassFromString(viewControllerName) else {
                throw RoutingError.compositionFailed(.init("Can not find \(viewControllerName) in the bundle."))
            }
            guard let customViewControllerClass = customClass as? VC.Type else {
                throw RoutingError.typeMismatch(customClass.self, .init("\(viewControllerName) is not an " +
                        "expected UIViewController type class."))
            }

            return customViewControllerClass.init(nibName: nibName, bundle: bundle)
        } else {
            return ViewController(nibName: nibName, bundle: bundle)
        }
    }

}
