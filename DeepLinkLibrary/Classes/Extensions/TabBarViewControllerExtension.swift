//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

extension UITabBarController: ContainerViewController {

    @discardableResult
    public func makeActive(vc: UIViewController) -> UIViewController? {
        guard let viewControllers = self.viewControllers else {
            return nil
        }

        for viewController in viewControllers {
            if let _ = UIViewController.findViewControllerDeep(in: viewController, oneLevelOnly: true, using: { controller in
                if let container = controller as? ContainerViewController {
                    container.makeActive(vc: vc)
                }
                return controller == vc
            }) {
                self.selectedViewController = viewController
                return viewController
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
