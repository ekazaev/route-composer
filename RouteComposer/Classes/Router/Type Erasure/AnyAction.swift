//
// Created by Eugene Kazaev on 08/09/2018.
//

import Foundation
import UIKit

protocol AnyAction {

    var embeddable: Bool { get }

    func perform(with viewController: UIViewController,
                 on existingController: UIViewController,
                 animated: Bool,
                 completion: @escaping (_: ActionResult) -> Void)

    func perform(embedding viewController: UIViewController,
                 in childViewControllers: inout [UIViewController])

}

protocol AnyActionBox: AnyAction {

    associatedtype ActionType: AbstractAction

    init(_ action: ActionType)

}

struct ActionBox<A: Action>: AnyAction, AnyActionBox, CustomStringConvertible {

    let action: A

    init(_ action: A) {
        self.action = action
    }

    let embeddable: Bool = false

    func perform(with viewController: UIViewController, on existingController: UIViewController, animated: Bool, completion: @escaping (ActionResult) -> Void) {
        guard let typedExistingViewController = existingController as? A.ViewController else {
            completion(.failure(RoutingError.typeMismatch(ActionType.ViewController.self, RoutingError.Context(debugDescription: "Action \(action.self) cannot " +
                    "be performed on \(existingController)."))))
            return
        }
        action.perform(with: viewController, on: typedExistingViewController, animated: animated, completion: completion)
    }

    func perform(embedding viewController: UIViewController, in childViewControllers: inout [UIViewController]) {
        childViewControllers.append(viewController)
    }

    public var description: String {
        return String(describing: action)
    }

}

struct ContainerActionBox<A: ContainerAction>: AnyAction, AnyActionBox, CustomStringConvertible {

    let action: A

    init(_ action: A) {
        self.action = action
    }

    let embeddable: Bool = true

    func perform(with viewController: UIViewController, on existingController: UIViewController, animated: Bool, completion: @escaping (ActionResult) -> Void) {
        guard let containerController: A.ViewController = UIViewController.findContainer(of: existingController) else {
            completion(.failure(RoutingError.typeMismatch(ActionType.ViewController.self, RoutingError.Context(debugDescription: "Container of " +
                    "\(String(describing: ActionType.ViewController.self)) type cannot be found to perform \(action)"))))
            return
        }

        action.perform(with: viewController, on: containerController, animated: animated, completion: completion)
    }

    func perform(embedding viewController: UIViewController, in childViewControllers: inout [UIViewController]) {
        action.perform(embedding: viewController, in: &childViewControllers)
    }

    public var description: String {
        return String(describing: action)
    }

}
