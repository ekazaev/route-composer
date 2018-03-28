//
// Created by Eugene Kazaev on 20/01/2018.
//

import Foundation
import UIKit

/// Dummy class to be provided to an assembly to show that this that never should be found in a view controller stack
/// and should always be created from scratch.
/// The only purpose it exist is to provide type safety checks for `StepAssembly`.
///
/// For example UIViewController of this step was already loaded and integrated in to a stack by a storyboard.
public class NilFinder<VC: UIViewController, C>: Finder {

    /// Type of UIViewController that Finder can find
    public typealias ViewController = VC

    /// Type of Context object that finder can deal with
    public typealias Context = C

    public init() {
    }

    public func findViewController(with context: Context) -> ViewController? {
        return nil
    }

}
