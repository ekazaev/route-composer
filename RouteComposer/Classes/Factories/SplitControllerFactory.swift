//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright © 2018 HBC Digital. All rights reserved.
//

import Foundation
import UIKit

///  The `ContainerFactory` that creates a `UISplitController` instance.
public struct SplitControllerFactory<C>: SimpleContainerFactory {

    public typealias ViewController = UISplitViewController

    public typealias Context = C

    /// `UISplitViewControllerDelegate` reference
    private(set) public weak var delegate: UISplitViewControllerDelegate?

    /// A property that controls how the primary view controller is hidden and displayed.
    /// A value of `.automatic` specifies the default behavior split view controller, which on an iPad,
    /// corresponds to an overlay mode in portrait and a side-by-side mode in landscape.
    public let preferredDisplayMode: UISplitViewController.DisplayMode?

    /// If 'true', hidden view can be presented and dismissed via a swipe gesture. Defaults to 'true'.
    public let presentsWithGesture: Bool?

    /// Block to configure `UISplitViewController`
    public let configuration: ((_: UISplitViewController) -> Void)?

    /// Constructor
    public init(delegate: UISplitViewControllerDelegate? = nil,
                presentsWithGesture: Bool? = nil,
                isCollapsed: Bool? = nil,
                preferredDisplayMode: UISplitViewController.DisplayMode? = nil,
                configuration: ((_: UISplitViewController) -> Void)? = nil) {
        self.delegate = delegate
        self.preferredDisplayMode = preferredDisplayMode
        self.presentsWithGesture = presentsWithGesture
        self.configuration = configuration
    }

    public func build(with context: C, integrating viewControllers: [UIViewController]) throws -> UISplitViewController {
        guard !viewControllers.isEmpty else {
            throw RoutingError.compositionFailed(.init("No master or derails view controllers provided."))
        }

        let splitController = UISplitViewController(nibName: nil, bundle: nil)
        if let presentsWithGesture = presentsWithGesture {
            splitController.presentsWithGesture = presentsWithGesture
        }
        if let preferredDisplayMode = preferredDisplayMode {
            splitController.preferredDisplayMode = preferredDisplayMode
        }
        if let delegate = delegate {
            splitController.delegate = delegate
        }
        if let configuration = configuration {
            configuration(splitController)
        }
        splitController.viewControllers = viewControllers
        return splitController
    }

}
