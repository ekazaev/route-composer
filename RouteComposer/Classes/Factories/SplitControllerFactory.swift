//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright © 2018 HBC Digital. All rights reserved.
//

import Foundation
import UIKit

///  The `ContainerFactory` that creates a `UISplitController` instance.
public struct SplitControllerFactory<VC: UISplitViewController, C>: ContainerFactory {

    public typealias ViewController = VC

    public typealias Context = C

    /// A Xib file name
    public let nibName: String?

    /// A `Bundle` instance
    public let bundle: Bundle?

    /// `UISplitViewControllerDelegate` reference
    private(set) public weak var delegate: UISplitViewControllerDelegate?

    /// If 'true', hidden view can be presented and dismissed via a swipe gesture. Defaults to 'true'.
    public let presentsWithGesture: Bool?

    /// A property that controls how the primary view controller is hidden and displayed.
    /// A value of `.automatic` specifies the default behavior split view controller, which on an iPad,
    /// corresponds to an overlay mode in portrait and a side-by-side mode in landscape.
    public let preferredDisplayMode: UISplitViewController.DisplayMode?

    /// The additional configuration block
    public let configuration: ((_: VC) -> Void)?

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

    public func build(with context: C, integrating coordinator: ChildCoordinator<C>) throws -> VC {
        let splitViewController = VC(nibName: nibName, bundle: bundle)
        if let presentsWithGesture = presentsWithGesture {
            splitViewController.presentsWithGesture = presentsWithGesture
        }
        if let delegate = delegate {
            splitViewController.delegate = delegate
        }
        if !coordinator.isEmpty {
            splitViewController.viewControllers = try coordinator.build(with: context, integrating: splitViewController.viewControllers)
        }
        if let preferredDisplayMode = preferredDisplayMode {
            splitViewController.preferredDisplayMode = preferredDisplayMode
        }
        if let configuration = configuration {
            configuration(splitViewController)
        }
        return splitViewController
    }

}
