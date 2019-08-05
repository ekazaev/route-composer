//
// Created by Eugene Kazaev on 16/07/2018.
//

import Foundation
import UIKit

/// `InlinePostTask` is the inline context task.
///
/// **NB:** It may be used for the purpose of configuration testing, but then replaced with a strongly typed
/// `PostRoutingTask` instance.
public struct InlinePostTask<VC: UIViewController, C>: PostRoutingTask {

    private let completion: (_: VC, _: C, _: [UIViewController]) -> Void

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
