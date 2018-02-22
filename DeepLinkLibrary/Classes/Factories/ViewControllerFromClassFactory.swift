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

    public func build() -> FactoryBuildResult {
        guard let myClass = NSClassFromString(self.viewControllerName) as? ViewController.Type else {
            return .failure("Can not find \(self.viewControllerName) in bundle")
        }

        return .success(myClass.init(nibName: nil, bundle: nil))
    }

}
