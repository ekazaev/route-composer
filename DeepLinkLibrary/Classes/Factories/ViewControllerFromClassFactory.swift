//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

public class ViewControllerFromClassFactory<VC: UIViewController, C>: Factory {

    public typealias ViewController = VC

    public typealias Context = C

    public let action: Action

    private let viewControllerName: String

    public init(viewControllerName: String, action: Action) {
        self.action = action
        self.viewControllerName = viewControllerName
    }

    public func build(with context: Context?) throws -> UIViewController {
        guard let myClass = NSClassFromString(self.viewControllerName) as? ViewController.Type else {
            throw RoutingError.message("Can not find \(self.viewControllerName) in bundle")
        }

        return myClass.init(nibName: nil, bundle: nil)
    }

}
