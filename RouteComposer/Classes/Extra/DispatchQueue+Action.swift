//
// RouteComposer
// DispatchQueue+Action.swift
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

/// Extension that wraps actions into `DispatchQueue` and delays it for the provided time interval.
///
/// Can be used to test action implementation or the configuration issues.
public extension DispatchQueue {

    /// Wraps `Action` in to `DispatchQueue`
    ///
    /// Parameters:
    ///  - action: `Action` instance
    ///  - timeInterval: `DispatchTimeInterval` instance
    static func delay<A: Action>(_ action: A, for timeInterval: DispatchTimeInterval = .milliseconds(300)) -> DispatchQueueWrappedAction<A> {
        DispatchQueueWrappedAction(action, timeInterval: timeInterval)
    }

    /// Wraps `ContainerAction` in to `DispatchQueue`
    ///
    /// Parameters:
    ///  - action: `ContainerAction` instance
    ///  - timeInterval: `DispatchTimeInterval` instance
    static func delay<A: ContainerAction>(_ action: A, for timeInterval: DispatchTimeInterval = .milliseconds(300)) -> DispatchQueueWrappedContainerAction<A> {
        DispatchQueueWrappedContainerAction(action, timeInterval: timeInterval)
    }

}

/// `CATransaction` wrapper for `Action`
public struct DispatchQueueWrappedAction<A: Action>: Action {

    // MARK: Associated types

    /// Type of the `UIViewController` that `Action` can start from.
    public typealias ViewController = A.ViewController

    // MARK: Properties

    let action: A

    let timeInterval: DispatchTimeInterval

    // MARK: Methods

    init(_ action: A, timeInterval: DispatchTimeInterval) {
        self.action = action
        self.timeInterval = timeInterval
    }

    public func perform(with viewController: UIViewController, on existingController: A.ViewController, animated: Bool, completion: @escaping (RoutingResult) -> Void) {
        guard animated else {
            action.perform(with: viewController, on: existingController, animated: false, completion: completion)
            return
        }
        action.perform(with: viewController, on: existingController, animated: true, completion: { result in
            guard result.isSuccessful else {
                completion(result)
                return
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + timeInterval) {
                completion(result)
            }
        })
    }

}

/// `CATransaction` wrapper for `ContainerAction`
public struct DispatchQueueWrappedContainerAction<A: ContainerAction>: ContainerAction {

    // MARK: Associated types

    /// Type of the `UIViewController` that `Action` can start from.
    public typealias ViewController = A.ViewController

    // MARK: Properties

    let action: A

    let timeInterval: DispatchTimeInterval

    // MARK: Methods

    init(_ action: A, timeInterval: DispatchTimeInterval) {
        self.action = action
        self.timeInterval = timeInterval
    }

    public func perform(embedding viewController: UIViewController, in childViewControllers: inout [UIViewController]) throws {
        try action.perform(embedding: viewController, in: &childViewControllers)
    }

    public func perform(with viewController: UIViewController, on existingController: A.ViewController, animated: Bool, completion: @escaping (RoutingResult) -> Void) {
        guard animated else {
            action.perform(with: viewController, on: existingController, animated: false, completion: completion)
            return
        }
        action.perform(with: viewController, on: existingController, animated: true, completion: { result in
            guard result.isSuccessful else {
                completion(result)
                return
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + timeInterval) {
                completion(result)
            }
        })
    }

}
