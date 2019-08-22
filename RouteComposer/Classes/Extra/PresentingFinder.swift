//
// Created by Eugene Kazaev on 2019-03-19.
//

import Foundation
import UIKit

/// `PresentingFinder` returns the presenting `UIViewController` of the topmost one in current stack.
public struct PresentingFinder<C>: Finder {

    // MARK: Properties

    /// `WindowProvider` instance.
    public let windowProvider: WindowProvider

    // MARK: Methods

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
