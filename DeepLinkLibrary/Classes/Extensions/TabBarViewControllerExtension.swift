//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

extension UITabBarController: ContainerViewController {

    @discardableResult
    public func makeActive(viewController: UIViewController, animated: Bool) -> UIViewController? {
        guard let viewControllers = self.viewControllers else {
            return nil
        }

        for vc in viewControllers {
            if let _ = UIViewController.findViewController(in: vc, options: .sameLevel, using: { controller in
                if let container = controller as? ContainerViewController {
                    container.makeActive(viewController: viewController, animated: animated)
                }
                return controller == viewController
            }) {
                self.selectedViewController = vc
                return vc
            }
        }

        return nil
    }
}

extension UITabBarController: RouterRulesViewController {

    public var canBeDismissed: Bool {
        get {
            guard let viewControllers = self.viewControllers else {
                return true
            }
            return viewControllers.flatMap {
                $0 as? RouterRulesViewController
            }.first {
                !$0.canBeDismissed
            } == nil
        }
    }

}
