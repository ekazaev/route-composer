//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

public class ViewControllerFromStoryboard<VC: UIViewController, C>: Factory {

    public typealias ViewController = VC

    public typealias Context = C

    public let action: Action

    private let storyboardName: String

    private let viewControllerID: String?

    public init(storyboardName: String, viewControllerID: String? = nil, action: Action) {
        self.action = action
        self.storyboardName = storyboardName
        self.viewControllerID = viewControllerID
    }

    public func build(with context: Context?) throws -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        if let viewControllerID = viewControllerID {
            guard let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerID) as? VC else {
                throw RoutingError.message("Unable to instantiate UIViewController with identifier \(viewControllerID) in \(storyboardName) storyboard")
            }
            return viewController
        } else {
            guard let abstractViewController = storyboard.instantiateInitialViewController() else {
                throw RoutingError.message("Unable to instantiate initial UIViewController in \(storyboardName) storyboard")
            }
            guard let viewController = abstractViewController as? ViewController else {
                throw RoutingError.message("Unable to instantiate initial UIViewController in \(storyboardName) storyboard as \(String(describing: type(of: ViewController.self))), got \(String(describing: abstractViewController)) instead.")
            }

            return viewController
        }
    }

}

