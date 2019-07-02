//
// Created by Eugene Kazaev on 2019-03-19.
// Copyright © 2019 HBC Digital. All rights reserved.
//

import Foundation
import UIKit

/// `PresentingFinder` returns the presenting `UIViewController` of the topmost one in current stack.
public struct PresentingFinder<C>: Finder {

    let windowProvider: WindowProvider

    /// Constructor
    ///
    /// - Parameter windowProvider: `WindowProvider` instance.
    public init(windowProvider: WindowProvider = KeyWindowProvider()) {
        self.windowProvider = windowProvider
    }

    public func findViewController(with context: C) throws -> UIViewController? {
        return windowProvider.window?.topmostViewController?.presentingViewController
    }

}
