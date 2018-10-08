//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import UIKit

/// The `Factory` that creates a `UIViewController` from a storyboard.
public struct StoryboardFactory<VC: UIViewController, C>: Factory {

    public typealias ViewController = VC

    public typealias Context = C

    /// The name of a storyboard file
    public let storyboardName: String

    /// The `Bundle` instance
    public let bundle: Bundle?

    /// The `UIViewController` identifier in the storyboard. If it is not set, the `Factory` will try
    /// to create the storyboards initial `UIViewController`
    public let viewControllerID: String?

    /// Constructor
    ///
    /// - Parameters:
    ///   - storyboardName: The name of a storyboard file
    ///   - bundle: The `Bundle` instance if needed
    ///   - viewControllerID: The `UIViewController` identifier in the storyboard. If it is not set, the `Factory` will try
    ///     to create the storyboards initial `UIViewController`
    public init(storyboardName: String, bundle: Bundle? = nil, viewControllerID: String? = nil) {
        self.storyboardName = storyboardName
        self.bundle = bundle
        self.viewControllerID = viewControllerID
    }

    public func build(with context: Context) throws -> ViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        if let viewControllerID = viewControllerID {
            let instantiatedViewController = storyboard.instantiateViewController(withIdentifier: viewControllerID)
            guard let viewController = instantiatedViewController as? VC else {
                throw RoutingError.message("Unable to instantiate UIViewController with " +
                        " \(viewControllerID) identifier in \(storyboardName) storyboard")
            }
            return viewController
        } else {
            guard let abstractViewController = storyboard.instantiateInitialViewController() else {
                throw RoutingError.message("Unable to instantiate initial UIViewController " +
                        "in \(storyboardName) storyboard")
            }
            guard let viewController = abstractViewController as? ViewController else {
                throw RoutingError.message("Unable to instantiate the initial UIViewController in \(storyboardName) " +
                        "storyboard as \(String(describing: type(of: ViewController.self))), " +
                        "got \(String(describing: abstractViewController)) instead.")
            }

            return viewController
        }
    }

}
