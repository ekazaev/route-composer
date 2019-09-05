//
// Created by Eugene Kazaev on 2019-09-05.
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
    static func delay<A: Action>(_ action: A, for timeInterval: DispatchTimeInterval) -> DispatchQueueWrappedAction<A> {
        return DispatchQueueWrappedAction(action, timeInterval: timeInterval)
    }

    /// Wraps `ContainerAction` in to `DispatchQueue`
    ///
    /// Parameters:
    ///  - action: `ContainerAction` instance
    ///  - timeInterval: `DispatchTimeInterval` instance
    static func delay<A: ContainerAction>(_ action: A, for timeInterval: DispatchTimeInterval) -> DispatchQueueWrappedContainerAction<A> {
        return DispatchQueueWrappedContainerAction(action, timeInterval: timeInterval)
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
        self.action.perform(with: viewController, on: existingController, animated: true, completion: { result in
            guard result.isSuccessful else {
                return completion(result)
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.timeInterval) {
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
        self.action.perform(with: viewController, on: existingController, animated: true, completion: { result in
            guard result.isSuccessful else {
                return completion(result)
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.timeInterval) {
                completion(result)
            }
        })
    }

}
