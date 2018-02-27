//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UITabBarController extension to support ContainerViewController protocol
extension UITabBarController: ContainerViewController {

    public func makeVisible(viewController: UIViewController, animated: Bool){
        guard let viewControllers = self.viewControllers else {
            return
        }

        for vc in viewControllers {
            if vc == viewController {
                self.selectedViewController = vc
                return
            }
        }
    }

}

// MARK: - UITabBarController extension to support RouterRulesSupport protocol
extension UITabBarController: RouterRulesSupport {

    public var canBeDismissed: Bool {
        get {
            guard let viewControllers = self.viewControllers else {
                return true
            }
            return viewControllers.flatMap {
                $0 as? RouterRulesSupport
            }.first {
                !$0.canBeDismissed
            } == nil
        }
    }

}
