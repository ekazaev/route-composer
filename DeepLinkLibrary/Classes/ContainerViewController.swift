//
//  ContainerViewController.swift
//  DeepLinkLibrary
//
//  Created by Alexandra Mikhailouskaya on 23/01/2018.
//

import Foundation
import UIKit

// @objc is mandatory otherwise crashes in runtime everywhere where Self: UIViewController
@objc public protocol ContainerViewController: RouterRulesSupport {

    /// Each container view controller should conform to this protocol for the router to know how to make
    /// the particular child view controller visible.
    ///
    /// - parameters:
    ///   - vc: UIViewController to make active (visible).
    ///   - animated: If container view controller is able to do so - make container active animated or not.
    func makeVisible(viewController: UIViewController, animated: Bool)

}
