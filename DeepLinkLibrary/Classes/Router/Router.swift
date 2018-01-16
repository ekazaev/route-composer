//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit
import Foundation


@objc public  protocol RouterRulesViewController where Self: UIViewController {

    var canBeDismissed: Bool { get }
}

@objc public protocol ContainerViewController: RouterRulesViewController {

    @discardableResult
    func makeActive(vc: UIViewController) -> UIViewController?

}

public protocol Router {

    @discardableResult
    func deepLinkTo<A: DeepLinkDestination>(destination: A, completion: (() -> Void)?) -> DeepLinkResult
}
