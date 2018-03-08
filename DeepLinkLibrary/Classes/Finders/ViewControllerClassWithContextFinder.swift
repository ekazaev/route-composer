//
// Created by Eugene Kazaev on 27/02/2018.
//

import Foundation
import UIKit

/// Default implementation of the unique view controller finder, where view controller can be found by name
/// and it context object.
///
/// Your view controller should extend ContextFinderSupport to use this finder.
public class ViewControllerClassWithContextFinder<VC: ContextFinderSupport, C>: FinderWithPolicy where VC.Context == C {

    public typealias ViewController = VC

    public typealias Context = C

    public let policy: FinderPolicy

    public init(policy: FinderPolicy = .allStackUp) {
        self.policy = policy
    }

    public func isTarget(viewController: ViewController, context: Context) -> Bool {
        return viewController.isSuitableFor(context: context)
    }

}

public protocol ContextFinderSupport where Self: UIViewController {

    associatedtype Context

    func isSuitableFor(context: Context) -> Bool

}