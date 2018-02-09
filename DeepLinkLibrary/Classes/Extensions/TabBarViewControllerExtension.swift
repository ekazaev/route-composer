//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

extension UITabBarController: ContainerViewController {

    @discardableResult
    public func makeVisible(viewController: UIViewController, animated: Bool) -> UIViewController? {
        guard let viewControllers = self.viewControllers else {
            return nil
        }

        for vc in viewControllers {
            if vc == viewController {
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
