//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

/// Default implementation of the unique view controller finder, where view controller can be found by name.
/// (Example: Home, account, login, etc supposed to be in the view stack just once)
public class ViewControllerClassFinder: FinderWithPolicy {

    let classType: UIViewController.Type

    public let policy: FinderPolicy

    public init(classType: UIViewController.Type, policy: FinderPolicy = .allStackUp) {
        self.classType = classType
        self.policy = policy
    }

    public func isTarget(viewController: UIViewController, arguments: Any?) -> Bool {
        return type(of: viewController) == classType
    }
}
