//
// Created by Eugene Kazaev on 16/07/2018.
//

import Foundation
import UIKit

/// `InlineContextTask`
///
/// **NB:** It may be used for the purpose of configuration testing, but then replaced with a strongly typed
/// `RoutingInterceptor` instance.
public struct InlineContextTask<VC: UIViewController, C>: ContextTask {

    // MARK: Properties

    private let completion: (_: VC, _: C) throws -> Void

    // MARK: Methods

    /// Constructor
    ///
    /// - Parameter completion: the block to be called when `InlineContextTask` will be applied to the `UIViewController`
    ///    instance.
    public init(_ completion: @escaping (_: VC, _: C) throws -> Void) {
        self.completion = completion
    }

    public func perform(on viewController: VC, with context: C) throws {
        try completion(viewController, context)
    }

}
