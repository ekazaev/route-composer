//
// Created by Eugene Kazaev on 2019-08-21.
//

import UIKit

/// Helper instance used to update the stack of `UIViewController`s
public protocol StackPresentationHandler {

    /// Makes `UIViewController` active in the current stack.
    ///
    /// - Parameters:
    ///   - viewController: `UIViewController` to make active.
    ///   - animated: Update stack with animation where possible.
    ///   - completion: Completion block
    func makeActive(_ viewController: UIViewController,
                    animated: Bool,
                    completion: @escaping (RoutingResult) -> Void)

}
