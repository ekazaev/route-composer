//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

/// Simple class that helps in implementation of finders that are looking for view controllers that can only
/// have one instance in view controller stack. So it enough just to look for this UIViewControllers just by a
/// class name that represets them. (Example: Home, account, login view controller e.t.c have only one instance)
public class ViewControllerClassFinder: FinderWithPolicy {

    let containerType: UIViewController.Type

    public let policy: FinderPolicy

    public init(containerType: UIViewController.Type, policy: FinderPolicy = .allStackUp) {
        self.containerType = containerType
        self.policy = policy
    }

    public func isTarget(viewController: UIViewController, arguments: Any?) -> Bool {
        return type(of: viewController) == containerType
    }
}
