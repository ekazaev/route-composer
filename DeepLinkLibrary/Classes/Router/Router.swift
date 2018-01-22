//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit
import Foundation


/// UIViewController's protocol exposed outside of library. If UIViewController extending this protocol wants to
/// overtake a controll of view controllers stack from router and forbid router to dismiss it or cover with another
/// UIViewController is has to retourn false when Router will ask this UIViewController if it can be dismissed.
@objc public  protocol RouterRulesViewController where Self: UIViewController {

    /// returns true if can be dismissed by Router, false otherwise.
    var canBeDismissed: Bool { get }
}

@objc public protocol ContainerViewController: RouterRulesViewController {

    @discardableResult
    /// Each container view controller should extend this protocol because router does not know how to make visible
    /// some particular child that container contains.
    ///
    /// - Parameters:
    ///   - vc: UIViewController to make active (visible).
    ///   - animated: If container view controller is able to do so - make container active animated or no.
    /// - Returns: UIViewController that actually been made active. Containers can be nested, e.g. UITabBarControllers
    /// or UISplitViewController can contain UINavigationController and vise versa, so Router will ask to make
    /// returned view controller to make a view controller that it make contain after.
    func makeActive(vc: UIViewController, animated: Bool) -> UIViewController?

}

public protocol Router {

    var logger: Logger? { get }

    @discardableResult
    func deepLinkTo<A: DeepLinkDestination>(destination: A, animated: Bool, completion: (() -> Void)?) -> DeepLinkResult
}
