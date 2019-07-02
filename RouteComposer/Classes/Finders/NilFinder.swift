//
// Created by Eugene Kazaev on 20/01/2018.
//

import Foundation
import UIKit

/// Dummy struct used to represent that nothing should be found in a view controller stack
/// and a `UIViewController` should always be created from scratch.
/// Its only purpose is to provide type safety checks for `StepAssembly`.
///
/// For example, `UIViewController` of this step was already loaded and integrated into a stack by a storyboard.
public struct NilFinder<VC: UIViewController, C>: Finder, NilEntity {

    /// Constructor
    public init() {
    }

    /// `Finder` method empty implementation.
    ///
    /// - Parameter context: A context instance provided.
    /// - Returns: always `nil`.
    public func findViewController(with context: C) throws -> VC? {
        return nil
    }

}
