//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

public class ViewControllerClassFinder: FinderWithPolicy {

    let containerType: UIViewController.Type

    public let policy: FinderPolicy

    public init(containerType: UIViewController.Type, policy: FinderPolicy = .allStack) {
        self.containerType = containerType
        self.policy = policy
    }

    public func isTarget(viewController: UIViewController, arguments: Any?) -> Bool {
        return type(of: viewController) == containerType
    }
}
