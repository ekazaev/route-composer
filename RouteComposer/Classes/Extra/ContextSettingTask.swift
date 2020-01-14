//
// Created by Eugene Kazaev on 2019-03-15.
//

#if os(iOS)

import Foundation
import UIKit

/// `ContextTask` that simplifies setting of the context to the `UIViewController` that implements `ContextAccepting` protocol.
public struct ContextSettingTask<VC: ContextAccepting>: ContextTask {

    // MARK: Methods

    /// Constructor
    public init() {}

    public func prepare(with context: VC.Context) throws {
        try VC.checkCompatibility(with: context)
    }

    public func perform(on viewController: VC, with context: VC.Context) throws {
        try viewController.setup(with: context)
    }

}

#endif
