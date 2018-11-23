//
// Created by Eugene Kazaev on 08/09/2018.
//

import Foundation
import UIKit

protocol AnyAction {

    func perform(with viewController: UIViewController,
                 on existingController: UIViewController,
                 animated: Bool,
                 completion: @escaping (_: ActionResult) -> Void)

    func perform(embedding viewController: UIViewController,
                 in childViewControllers: inout [UIViewController]) throws

    func isEmbeddable<CF: ContainerFactory>(to container: CF) -> Bool

}

protocol AnyActionBox: AnyAction {

    associatedtype ActionType: AbstractAction

    init(_ action: ActionType)

}

struct ActionBox<A: Action>: AnyAction, AnyActionBox, CustomStringConvertible, MainThreadChecking {

    let action: A

    init(_ action: A) {
        self.action = action
    }

    func perform(with viewController: UIViewController, on existingController: UIViewController, animated: Bool, completion: @escaping (ActionResult) -> Void) {
        guard let typedExistingViewController = existingController as? A.ViewController else {
            completion(.failure(RoutingError.typeMismatch(ActionType.ViewController.self, RoutingError.Context(debugDescription: "Action \(action.self) cannot " +
                    "be performed on \(existingController)."))))
            return
        }
        assertIfNotMainThread()
        action.perform(with: viewController, on: typedExistingViewController, animated: animated) { result in
            self.assertIfNotMainThread()
            completion(result)
        }
    }

    func perform(embedding viewController: UIViewController, in childViewControllers: inout [UIViewController]) {
        childViewControllers.append(viewController)
    }

    public var description: String {
        return String(describing: action)
    }

    func isEmbeddable<CF: ContainerFactory>(to container: CF) -> Bool {
        return false
    }
}

struct ContainerActionBox<A: ContainerAction>: AnyAction, AnyActionBox, CustomStringConvertible, MainThreadChecking {

    let action: A

    init(_ action: A) {
        self.action = action
    }

    func perform(with viewController: UIViewController, on existingController: UIViewController, animated: Bool, completion: @escaping (ActionResult) -> Void) {
        guard let containerController: A.ViewController = UIViewController.findContainer(of: existingController) else {
            completion(.failure(RoutingError.typeMismatch(ActionType.ViewController.self, RoutingError.Context(debugDescription: "Container of " +
                    "\(String(describing: ActionType.ViewController.self)) type cannot be found to perform \(action)"))))
            return
        }
        assertIfNotMainThread()
        action.perform(with: viewController, on: containerController, animated: animated) { result in
            self.assertIfNotMainThread()
            completion(result)
        }
    }

    func perform(embedding viewController: UIViewController, in childViewControllers: inout [UIViewController]) throws {
        try action.perform(embedding: viewController, in: &childViewControllers)
    }

    public var description: String {
        return String(describing: action)
    }

    func isEmbeddable<CF: ContainerFactory>(to container: CF) -> Bool {
        return CF.ViewController.self is A.ViewController.Type
    }

}
