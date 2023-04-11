//
// RouteComposer
// InlinePostTask.swift
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

/// `InlinePostTask` is the inline context task.
///
/// **NB:** It may be used for the purpose of configuration testing, but then replaced with a strongly typed
/// `PostRoutingTask` instance.
public struct InlinePostTask<VC: UIViewController, C>: PostRoutingTask {

    // MARK: Properties

    private let completion: (_: VC, _: C, _: [UIViewController]) -> Void

    // MARK: Methods

    /// Constructor
    ///
    /// - Parameter completion: the block to be called when `InlinePostTask` will be called at the end of the navigation process
    ///   process.
    public init(_ completion: @escaping (_: VC, _: C, _: [UIViewController]) -> Void) {
        self.completion = completion
    }

    public func perform(on viewController: VC, with context: C, routingStack: [UIViewController]) {
        completion(viewController, context, routingStack)
    }

}
