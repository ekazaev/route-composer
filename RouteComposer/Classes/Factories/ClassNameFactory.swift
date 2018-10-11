//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import UIKit

/// The `Factory` that creates a `UIViewController` class by its name
public struct ClassNameFactory<VC: UIViewController, C>: Factory {

    public typealias ViewController = VC

    public typealias Context = C

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

    public func build(with context: Context) throws -> ViewController {
        if let viewControllerName = viewControllerName {
            guard let customClass = NSClassFromString(viewControllerName) else {
                throw RoutingError.compositionFailed(RoutingError.Context(debugDescription: "Can not find \(viewControllerName) in the bundle."))
            }
            guard let customViewControllerClass = customClass as? ViewController.Type else {
                throw RoutingError.typeMismatch(customClass.self, RoutingError.Context(debugDescription: "\(viewControllerName) is not a UIViewController type class."))
            }

            return customViewControllerClass.init(nibName: nil, bundle: nil)
        } else {
            return ViewController(nibName: nil, bundle: nil)
        }
    }

}
