//
// RouteComposer
// ContextSettingTask.swift
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
