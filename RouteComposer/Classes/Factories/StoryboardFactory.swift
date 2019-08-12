//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright © 2018 HBC Digital. All rights reserved.
//

import UIKit

/// The `Factory` that creates a `UIViewController` from a storyboard.
public struct StoryboardFactory<VC: UIViewController, C>: Factory {

    public typealias ViewController = VC

    public typealias Context = C

    /// The name of a storyboard file
    public let name: String

    /// The `Bundle` instance
    public let bundle: Bundle?

    /// The `UIViewController` identifier in the storyboard. If it is not set, the `Factory` will try
    /// to create the storyboards initial `UIViewController`
    public let identifier: String?

    /// The additional configuration block
    public let configuration: ((_: VC) -> Void)?

    /// Constructor
    ///
    /// - Parameters:
    ///   - storyboardName: The name of a storyboard file
    ///   - bundle: The `Bundle` instance if needed
    ///   - viewControllerID: The `UIViewController` identifier in the storyboard. If it is not set, the `Factory` will try
    ///     to create the storyboards initial `UIViewController`
    @available(*, deprecated, renamed: "init(name:bundle:identifier:configuration:)")
    public init(storyboardName: String, bundle: Bundle? = nil, viewControllerID: String? = nil) {
        self.name = storyboardName
        self.bundle = bundle
        self.identifier = viewControllerID
        self.configuration = nil
    }

    /// Constructor
    ///
    /// - Parameters:
    ///   - storyboardName: The name of a storyboard file
    ///   - bundle: The `Bundle` instance if needed
    ///   - identifier: The `UIViewController` identifier in the storyboard. If it is not set, the `Factory` will try
    ///     to create the storyboards initial `UIViewController`
    ///   - configuration: A block of code that will be used for the extended configuration of the created `UIViewController`. Can be used for
    ///                    a quick configuration instead of `ContextTask`.
    public init(name: String, bundle: Bundle? = nil, identifier: String? = nil, configuration: ((_: VC) -> Void)? = nil) {
        self.name = name
        self.bundle = bundle
        self.identifier = identifier
        self.configuration = configuration
    }

    public func build(with context: C) throws -> VC {
        guard let viewControllerID = identifier else {
            return try buildInitialViewController()
        }
        let storyboard = UIStoryboard(name: name, bundle: bundle)
        let instantiatedViewController = storyboard.instantiateViewController(withIdentifier: viewControllerID)
        guard let viewController = instantiatedViewController as? VC else {
            throw RoutingError.typeMismatch(type: type(of: instantiatedViewController),
                    expectedType: VC.self,
                    .init("Unable to instantiate UIViewController with " +
                            " \(viewControllerID) identifier in \(name) storyboard " +
                            "as \(String(describing: type(of: VC.self))), got \(String(describing: instantiatedViewController)) instead."))
        }
        if let configuration = configuration {
            configuration(viewController)
        }
        return viewController
    }

    private func buildInitialViewController() throws -> VC {
        let storyboard = UIStoryboard(name: name, bundle: bundle)
        guard let abstractViewController = storyboard.instantiateInitialViewController() else {
            throw RoutingError.compositionFailed(.init("Unable to instantiate initial UIViewController " +
                    "in \(name) storyboard"))
        }
        guard let viewController = abstractViewController as? VC else {
            throw RoutingError.typeMismatch(type: type(of: abstractViewController),
                    expectedType: VC.self,
                    .init("Unable to instantiate the initial UIViewController in \(name) storyboard " +
                            "as \(String(describing: type(of: VC.self))), got \(String(describing: abstractViewController)) instead."))
        }
        if let configuration = configuration {
            configuration(viewController)
        }
        return viewController
    }

}
