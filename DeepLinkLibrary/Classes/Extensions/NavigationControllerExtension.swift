//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController: ContainerViewController {

    public func makeVisible(viewController: UIViewController, animated: Bool) {
        let viewControllers = self.viewControllers

        for vc in viewControllers {
            if vc == viewController {
                self.popToViewController(vc, animated: animated)
                return
            }
        }
    }

}

extension UINavigationController: RouterRulesSupport {

    public var canBeDismissed: Bool {
        get {
            return viewControllers.flatMap {
                $0 as? RouterRulesSupport
            }.first {
                !$0.canBeDismissed
            } == nil
        }
    }

}
