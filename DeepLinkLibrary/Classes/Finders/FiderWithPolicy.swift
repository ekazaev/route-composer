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

    var policy: FinderPolicy { get }

    func isTarget(viewController: V, arguments: A?) -> Bool

}

public extension FinderWithPolicy {

    func findViewController(with arguments: A?) -> V? {
        switch policy {
        case .allStackUp:
            guard let rootViewController = UIWindow.key?.rootViewController,
                  let viewController = UIViewController.findViewController(in: rootViewController, options: .sameAndUp, using: {
                      guard let vc = $0 as? V else {
                          return false
                      }
                      return isTarget(viewController: vc, arguments: arguments)
                  }) as? V else {
                return nil
            }
            return viewController
        case .allStackDown:
            guard let rootViewController = UIWindow.key?.topmostViewController,
                  let viewController = UIViewController.findViewController(in: rootViewController, options: .sameAndDown, using: {
                      guard let vc = $0 as? V else {
                          return false
                      }
                      return isTarget(viewController: vc, arguments: arguments)
                  }) as? V else {
                return nil
            }
            return viewController
        case .currentLevel:
            guard let topMostViewController = UIWindow.key?.topmostViewController,
                  let viewController = UIViewController.findViewController(in: topMostViewController, options: .sameLevel, using: {
                      guard let vc = $0 as? V else {
                          return false
                      }
                      return isTarget(viewController: vc, arguments: arguments)
                  }) as? V else {
                return nil
            }
            return viewController
        case .topMost:
            guard let topMostViewController = UIWindow.key?.topmostViewController as? V,
                  let viewController = (isTarget(viewController: topMostViewController, arguments: arguments) ? topMostViewController : nil) else {
                return nil
            }
            return viewController
        }
    }
}
