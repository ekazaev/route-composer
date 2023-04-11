//
// RouteComposer
// SplitControllerFactory.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import UIKit

///  The `ContainerFactory` that creates a `UISplitController` instance.
public struct SplitControllerFactory<VC: UISplitViewController, C>: ContainerFactory {

    // MARK: Associated types

    public typealias ViewController = VC

    public typealias Context = C

    // MARK: Properties

    /// A Xib file name
    public let nibName: String?

    /// A `Bundle` instance
    public let bundle: Bundle?

    /// `UISplitViewControllerDelegate` reference
    public private(set) weak var delegate: UISplitViewControllerDelegate?

    /// If 'true', hidden view can be presented and dismissed via a swipe gesture. Defaults to 'true'.
    public let presentsWithGesture: Bool?

    /// A property that controls how the primary view controller is hidden and displayed.
    /// A value of `.automatic` specifies the default behavior split view controller, which on an iPad,
    /// corresponds to an overlay mode in portrait and a side-by-side mode in landscape.
    public let preferredDisplayMode: UISplitViewController.DisplayMode?

    /// The additional configuration block
    public let configuration: ((_: VC) -> Void)?

    // MARK: Methods

    /// Constructor
    public init(nibName nibNameOrNil: String? = nil,
                bundle nibBundleOrNil: Bundle? = nil,
                delegate: UISplitViewControllerDelegate? = nil,
                presentsWithGesture: Bool? = nil,
                preferredDisplayMode: UISplitViewController.DisplayMode? = nil,
                configuration: ((_: VC) -> Void)? = nil) {
        self.nibName = nibNameOrNil
        self.bundle = nibBundleOrNil
        self.delegate = delegate
        self.preferredDisplayMode = preferredDisplayMode
        self.presentsWithGesture = presentsWithGesture
        self.configuration = configuration
    }

    public func build(with context: C, integrating coordinator: ChildCoordinator) throws -> VC {
        let splitViewController = VC(nibName: nibName, bundle: bundle)
        if let presentsWithGesture {
            splitViewController.presentsWithGesture = presentsWithGesture
        }
        if let delegate {
            splitViewController.delegate = delegate
        }
        if !coordinator.isEmpty {
            splitViewController.viewControllers = try coordinator.build(integrating: splitViewController.viewControllers)
        }
        if let preferredDisplayMode {
            splitViewController.preferredDisplayMode = preferredDisplayMode
        }
        if let configuration {
            configuration(splitViewController)
        }
        return splitViewController
    }

}
