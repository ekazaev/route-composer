//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

/// Default implementation of the unique view controller finder, where view controller can be found by name.
/// (Example: Home, account, login, etc supposed to be in the view stack just once)
public class ViewControllerClassFinder<VV:UIViewController, AA>: FinderWithPolicy {
    public typealias V = VV
    public typealias A = AA

    public let policy: FinderPolicy

    public init(policy: FinderPolicy = .allStackUp) {
        self.policy = policy
    }

    public func isTarget(viewController: V, arguments: A?) -> Bool {
        return true
    }

}
