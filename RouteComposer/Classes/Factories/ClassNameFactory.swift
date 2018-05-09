//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

/// `Factory` that creates `UIViewController` of desired class by its name
public class ClassNameFactory<VC: UIViewController, C>: Factory {

    public typealias ViewController = VC

    public typealias Context = C

    public let action: Action

    private let viewControllerName: String

    /// Constructor
    ///
    /// - Parameters:
    ///   - viewControllerName: The name of `UIViewController` class to be built
    ///   - action: The `Action` instance to integrate built `UIViewController` in to stack
    public init(viewControllerName: String, action: Action) {
        self.action = action
        self.viewControllerName = viewControllerName
    }

    public func build(with context: Context) throws -> ViewController {
        guard let customClass = NSClassFromString(self.viewControllerName) else {
            throw RoutingError.message("Can not find \(self.viewControllerName) in bundle")
        }
        guard let customViewControllerClass = customClass as? ViewController.Type else {
            throw RoutingError.message("\(self.viewControllerName) is not a UIViewController type class.")
        }

        return customViewControllerClass.init(nibName: nil, bundle: nil)
    }

}
