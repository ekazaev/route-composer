//
// RouteComposer
// AnyContextCheckingViewController.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2024.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import RouteComposer
import UIKit

// This view controller allows us to have the same ContextChecking UIViewController for testing
// as its currently is swift it is impossible to write `some UIViewController: ContextChecking where Context == SOMETHING`
@MainActor
class AnyContextCheckingViewController<Context: Equatable>: UIViewController, ContextChecking {

    func isTarget(for context: Context) -> Bool {
        fatalError("Must be implemented in the child")
    }
}
