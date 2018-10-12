//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit

///  The `Container` that creates a `UISplitController` instance.
public struct SplitControllerFactory<C>: SimpleContainer {

    public typealias ViewController = UISplitViewController

    public typealias Context = C

    /// `UISplitViewControllerDelegate` reference
    private(set) weak var delegate: UISplitViewControllerDelegate?

    /// A property that controls how the primary view controller is hidden and displayed.
    /// A value of `.automatic` specifies the default behavior split view controller, which on an iPad,
    /// corresponds to an overlay mode in portrait and a side-by-side mode in landscape.
    public let preferredDisplayMode: UISplitViewController.DisplayMode

    /// If 'true', hidden view can be presented and dismissed via a swipe gesture. Defaults to 'true'.
    public let presentsWithGesture: Bool

    /// Constructor
    public init(delegate: UISplitViewControllerDelegate? = nil,
                presentsWithGesture: Bool = true,
                isCollapsed: Bool = false,
                preferredDisplayMode: UISplitViewController.DisplayMode = .automatic) {        self.delegate = delegate
        self.preferredDisplayMode = preferredDisplayMode
        self.presentsWithGesture = presentsWithGesture
    }

    public func build(with context: Context, integrating viewControllers: [UIViewController]) throws -> ViewController {
        guard !viewControllers.isEmpty else {
            throw RoutingError.compositionFailed(RoutingError.Context(debugDescription: "No master or derails view controllers provided."))
        }

        let splitController = UISplitViewController(nibName: nil, bundle: nil)
        splitController.presentsWithGesture = presentsWithGesture
        splitController.preferredDisplayMode = preferredDisplayMode
        if let delegate = delegate {
            splitController.delegate = delegate
        }
        splitController.viewControllers = viewControllers
        return splitController
    }

}
