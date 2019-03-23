//
// Created by Eugene Kazaev on 2019-03-19.
// Copyright © 2019 HBC Digital. All rights reserved.
//

import Foundation
import UIKit

/// `DismissalMethodProvidingContextTask` allows to provide the way to dismiss the `UIViewController` using a preset configuration.
/// The `UIViewController` should conform to `Dismissible` protocol and call `Dismissible.dismissViewController(...)` method
/// when it needs to be dismissed to trigger the dismissal process implemented in `DismissalMethodProvidingContextTask.init(...)`
/// constructor.
public struct DismissalMethodProvidingContextTask<VC: Dismissible, C>: ContextTask {

    let dismissalBlock: (_: VC.DismissalTargetContext, _: Bool, _: ((_: RoutingResult) -> Void)?) -> Void

    /// Constructor
    ///
    /// - Parameter dismissalBlock: Block that will trigger the dismissal process when `Dismissible` `UIViewController` calls
    ///    `Dismissible.dismissViewController(...)` method.
    public init(dismissalBlock: @escaping (_: VC.DismissalTargetContext, _: Bool, _: ((_: RoutingResult) -> Void)?) -> Void) {
        self.dismissalBlock = dismissalBlock
    }

    public func apply(on viewController: VC, with context: C) throws {
        var viewController = viewController
        viewController.dismissalBlock = dismissalBlock
    }

}
