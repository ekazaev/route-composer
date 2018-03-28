//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import UIKit

/// Factory that creates UIViewController from storyboard.
public class StoryboardFactory<VC: UIViewController, C>: Factory {

    public typealias ViewController = VC

    public typealias Context = C

    public let action: Action

    private let storyboardName: String

    public let bundle: Bundle?

    private let viewControllerID: String?

    /// Constructor
    ///
    /// - Parameters:
    ///   - storyboardName: Name of storyboard file
    ///   - bundle: Bundle instance if needed
    ///   - viewControllerID: UIViewController identifier in storyboard. If not set - factory will try
    ///     to create storyboards's initial UIViewController
    ///   - action: Action instance to integrate built UIViewController in to stack
    public init(storyboardName: String, bundle: Bundle? = nil, viewControllerID: String? = nil, action: Action) {
        self.action = action
        self.storyboardName = storyboardName
        self.bundle = bundle
        self.viewControllerID = viewControllerID
    }

    public func build(with context: Context) throws -> ViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
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

