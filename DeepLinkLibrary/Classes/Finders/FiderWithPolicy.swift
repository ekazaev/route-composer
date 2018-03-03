//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

/// Simplifies creation of finders for a hosting app. If there is nothing special about finder, hosting app should
/// extend this finder which will just follow the finder policy and just ask extending instances if this particular
/// view controller is the one that Router looking for or no.
public protocol FinderWithPolicy: Finder {

    /// Policy to be used by FinderWithPolicy
    var policy: FinderPolicy { get }

    /// Method to be implemented by FinderWithPolicy instance
    ///
    /// - Parameters:
    ///   - viewController: Some view controller in the current view controller stack
    ///   - context: Context object that was provided to the Router.
    /// - Returns: true if this view controller is the one that finder is looking for, false otherwise.
    func isTarget(viewController: ViewController, context: Context?) -> Bool

}

public extension FinderWithPolicy {

    func findViewController(with context: Context?) -> ViewController? {

        let comparator: (UIViewController) -> Bool = {
            guard let vc = $0 as? ViewController else {
                return false
            }
            return self.isTarget(viewController: vc, context: context)
        }

        switch policy {
        case .allStackUp:
            guard let rootViewController = UIWindow.key?.rootViewController,
                  let viewController = UIViewController.findViewController(in: rootViewController, options: .currentAndUp, using: comparator) as? ViewController else {
                return nil
            }
            return viewController
        case .allStackDown:
            guard let rootViewController = UIWindow.key?.topmostViewController,
                  let viewController = UIViewController.findViewController(in: rootViewController, options: .currentAndDown, using: comparator) as? ViewController else {
                return nil
            }
            return viewController
        case .currentLevel:
            guard let topMostViewController = UIWindow.key?.topmostViewController,
                  let viewController = UIViewController.findViewController(in: topMostViewController, options: .current, using: comparator) as? ViewController else {
                return nil
            }
            return viewController
        case .topMost:
            guard let topMostViewController = UIWindow.key?.topmostViewController as? ViewController,
                  let viewController = (isTarget(viewController: topMostViewController, context: context) ? topMostViewController : nil) else {
                return nil
            }
            return viewController
        }
    }
}
