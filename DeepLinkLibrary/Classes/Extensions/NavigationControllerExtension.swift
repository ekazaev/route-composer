//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController: ContainerViewController {

    @discardableResult
    public func makeActive(viewController: UIViewController, animated: Bool) -> UIViewController? {
        let viewControllers = self.viewControllers

        for vc in viewControllers {
            if let _ = UIViewController.findViewController(in: vc, options: .sameLevel, using: { controller in
                if let container = controller as? ContainerViewController {
                    container.makeActive(viewController: viewController, animated: animated)
                }
                return controller == viewController
            }) {
                self.popToViewController(vc, animated: animated)
                return vc
            }
        }

        return nil
    }

}


extension UINavigationController: RouterRulesViewController {

    public var canBeDismissed: Bool {
        get {
            return viewControllers.flatMap {
                $0 as? RouterRulesViewController
            }.first {
                !$0.canBeDismissed
            } == nil
        }
    }

}
