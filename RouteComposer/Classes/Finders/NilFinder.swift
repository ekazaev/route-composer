//
// Created by Eugene Kazaev on 20/01/2018.
//

import Foundation
import UIKit

/// Dummy class to be provided to an assembly to show that this that never should be found in a view controller stack
/// and should always be created from scratch.
/// The only purpose it exists is to provide type safety checks for `StepAssembly`.
///
/// For example, `UIViewController` of this step was already loaded and integrated into a stack by a storyboard.
public struct NilFinder<VC: UIViewController, C>: Finder, NilEntity {

    /// Type of `UIViewController` that `Finder` can find
    public typealias ViewController = VC

    /// Type of `Context` object that `Finder` can deal with
    public typealias Context = C

    /// Constructor
    public init() {
    }

    /// `Finder` method empty implementation.
    ///
    /// - Parameter context: A context instance provided.
    /// - Returns: always `nil`.
    public func findViewController(with context: Context) -> ViewController? {
        return nil
    }

}
