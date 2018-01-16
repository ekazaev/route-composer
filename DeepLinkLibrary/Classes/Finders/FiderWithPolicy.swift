//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

public enum FinderPolicy {

    case allStack

    case currentLevel

    case topMost

}

public protocol FinderWithPolicy: DeepLinkFinder {

    var policy: FinderPolicy { get }

    func isTarget(viewController: UIViewController, arguments: Any?) -> Bool

}

public extension FinderWithPolicy {

    func findViewController(with arguments: Any?) -> UIKit.UIViewController? {
        switch policy {
        case .allStack:
            guard let rootViewController = UIWindow.key?.rootViewController else {
                return nil
            }
            return UIViewController.findViewControllerDeep(in: rootViewController, oneLevelOnly: false, using: { isTarget(viewController: $0, arguments: arguments) })
        case .currentLevel:
            guard let topMostViewController = UIWindow.key?.topmostViewController else {
                return nil
            }
            return UIViewController.findViewControllerDeep(in: topMostViewController, oneLevelOnly: true, using: { isTarget(viewController: $0, arguments: arguments) })
        case .topMost:
            guard let topMostViewController = UIWindow.key?.topmostViewController else {
                return nil
            }
            return isTarget(viewController: topMostViewController, arguments: arguments) ? topMostViewController : nil
        }
    }
}
