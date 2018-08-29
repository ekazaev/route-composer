//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import UIKit

/// The `Factory` that creates `UIViewController` from the storyboard.
public struct StoryboardFactory<VC: UIViewController, C>: Factory {

    public typealias ViewController = VC

    public typealias Context = C

    public let action: Action

    private let storyboardName: String

    private let bundle: Bundle?

    private let viewControllerID: String?

    /// Constructor
    ///
    /// - Parameters:
    ///   - storyboardName: The name of a storyboard file
    ///   - bundle: The Bundle instance if needed
    ///   - viewControllerID: The `UIViewController` identifier in storyboard. If not set - the `Factory` will try
    ///     to create a storyboards's initial `UIViewController`
    ///   - action: The `Action` instance to integrate built `UIViewController` into the stack
    public init(storyboardName: String, bundle: Bundle? = nil, viewControllerID: String? = nil, action: Action) {
        self.action = action
        self.storyboardName = storyboardName
        self.bundle = bundle
        self.viewControllerID = viewControllerID
    }

    public func build(with context: Context) throws -> ViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        if let viewControllerID = viewControllerID {
            let instantiatedViewController = storyboard.instantiateViewController(withIdentifier: viewControllerID)
            guard let viewController = instantiatedViewController as? VC else {
                throw RoutingError.message("Unable to instantiate UIViewController with identifier" +
                        " \(viewControllerID)  in \(storyboardName) storyboard")
            }
            return viewController
        } else {
            guard let abstractViewController = storyboard.instantiateInitialViewController() else {
                throw RoutingError.message("Unable to instantiate initial UIViewController " +
                        "in \(storyboardName) storyboard")
            }
            guard let viewController = abstractViewController as? ViewController else {
                throw RoutingError.message("Unable to instantiate initial UIViewController in \(storyboardName) " +
                        "storyboard as \(String(describing: type(of: ViewController.self))), " +
                        "got \(String(describing: abstractViewController)) instead.")
            }

            return viewController
        }
    }

}
