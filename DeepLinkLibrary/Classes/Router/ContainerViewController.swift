//
//  ContainerViewController.swift
//  DeepLinkLibrary
//
//  Created by Alexandra Mikhailouskaya on 23/01/2018.
//

import Foundation
import UIKit

@objc public protocol ContainerViewController: RouterRulesViewController {
    
    @discardableResult
    /// Each container view controller should conform to this protocol for the router to know how to make
    /// the particular child view controller visible.
    ///
    /// - parameters:
    ///   - vc: UIViewController to make active (visible).
    ///   - animated: If container view controller is able to do so - make container active animated or not.
    /// - returns: UIViewController that actually been made active. Containers can be nested, e.g. UITabBarControllers
    ///   or UISplitViewController can contain UINavigationController and vise versa, so Router will ask to make
    ///   returned view controller to make a view controller that it make contain after.
    func makeActive(vc: UIViewController, animated: Bool) -> UIViewController?
    
}
