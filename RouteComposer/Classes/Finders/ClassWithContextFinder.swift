//
// Created by Eugene Kazaev on 27/02/2018.
//

import Foundation
import UIKit

/// A default implementation of the unique view controller finder, where view controller can be found by name
/// and it `Context` instance.
///
/// Your view controller should extend `ContextChecking` to be used with this finder.
public struct ClassWithContextFinder<VC: ContextChecking, C>: StackIteratingFinder where VC.Context == C {

    /// `UIViewController` type associated with this `ClassWithContextFinder`
    public typealias ViewController = VC

    /// The context type associated with this `ClassWithContextFinder`
    public typealias Context = C

    /// `SearchOptions` to be used by `ClassWithContextFinder`
    public let options: SearchOptions

    /// Constructor
    ///
    /// - Parameter options: A combination of the `SearchOptions`
    public init(options: SearchOptions = .currentAndUp) {
        self.options = options
    }

    public func isTarget(_ viewController: ViewController, with context: Context) -> Bool {
        return viewController.isTarget(for: context)
    }

}

/// `UIViewController` instance should extend this protocol to be used with `ClassWithContextFinder`
public protocol ContextChecking where Self: UIViewController {

    /// The context type associated with a `ContextChecking` `UIViewController`
    associatedtype Context

    /// If this view controller is suitable for the `Context` instance provided, like already showing provided
    /// context data or willing to do so it should return `true`, `false` otherwise.
    /// - Parameters:
    ///     - context: The `Context` instance provided to the `Router`
    func isTarget(for context: Context) -> Bool

}
