//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController: ContainerViewController {

    @discardableResult
    public func makeActive(vc: UIViewController, animated: Bool) -> UIViewController? {
        let viewControllers = self.viewControllers

        for viewController in viewControllers {
            if let _ = UIViewController.findViewController(in: viewController, options: .sameLevel, using: { controller in
                if let container = controller as? ContainerViewController {
                    container.makeActive(vc: vc, animated: animated)
                }
                return controller == vc
            }) {
                self.popToViewController(viewController, animated: animated)
                return viewController
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
