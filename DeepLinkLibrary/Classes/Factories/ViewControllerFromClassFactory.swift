//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

public class ViewControllerFromClassFactory: Factory {

    public let action: Action

    private let viewControllerName: String

    public init(viewControllerName: String, action: Action) {
        self.action = action
        self.viewControllerName = viewControllerName
    }

    public func build(with logger: Logger?) -> UIViewController? {
        guard let myClass = NSClassFromString(self.viewControllerName) as? UIViewController.Type else {
            logger?.log(.error("Can not find \(self.viewControllerName) in bundle"))
            return nil
        }

        return myClass.init(nibName: nil, bundle: nil)
    }

}
