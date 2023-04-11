//
// RouteComposer
// DismissalMethodProvidingContextTask.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import UIKit

/// `DismissalMethodProvidingContextTask` allows to provide the way to dismiss the `UIViewController` using a preset configuration.
/// The `UIViewController` should conform to `Dismissible` protocol and call `Dismissible.dismissViewController(...)` method
/// when it needs to be dismissed to trigger the dismissal process implemented in `DismissalMethodProvidingContextTask.init(...)`
/// constructor.
public struct DismissalMethodProvidingContextTask<VC: Dismissible, C>: ContextTask {

    // MARK: Properties

    let dismissalBlock: (_: VC, _: VC.DismissalTargetContext, _: Bool, _: ((_: RoutingResult) -> Void)?) -> Void

    // MARK: Methods

    /// Constructor
    ///
    /// - Parameter dismissalBlock: Block that will trigger the dismissal process when `Dismissible` `UIViewController` calls
    ///    `Dismissible.dismissViewController(...)` method.
    public init(dismissalBlock: @escaping (_: VC, _: VC.DismissalTargetContext, _: Bool, _: ((_: RoutingResult) -> Void)?) -> Void) {
        self.dismissalBlock = dismissalBlock
    }

    public func perform(on viewController: VC, with context: C) throws {
        viewController.dismissalBlock = dismissalBlock
    }

}
