//
// Created by Eugene Kazaev on 2018-10-13.
//

import Foundation
import UIKit

/// Searches for the enclosing container of the child view controller found by a provided finder.
public struct EnclosingContainerFinder<VC: ContainerViewController, F: Finder>: Finder {

    let finder: F

    /// Constructor
    ///
    /// - Parameters:
    ///   - finder: The `UIViewController` `Finder` instance.
    public init(using finder: F) {
        self.finder = finder
    }

    public func findViewController(with context: F.Context) -> VC? {
        guard let childViewController = finder.findViewController(with: context) else {
            return nil
        }
        return UIViewController.findContainer(of: childViewController)
    }

}
