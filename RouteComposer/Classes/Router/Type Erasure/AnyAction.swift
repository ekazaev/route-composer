//
// Created by Eugene Kazaev on 08/09/2018.
//

import Foundation
import UIKit

protocol AnyAction {

    var nestedActionHelper: NestedActionHelper? { get set }

    func perform(with viewController: UIViewController,
                 on existingController: UIViewController,
                 animated: Bool,
                 completion: @escaping (_: ActionResult) -> Void)

    func perform(embedding viewController: UIViewController,
                 in childViewControllers: inout [UIViewController]) throws

    func isEmbeddable(to container: ContainerViewController.Type) -> Bool

}

protocol AnyActionBox: AnyAction {

    associatedtype ActionType: AbstractAction

    init(_ action: ActionType)

}

struct ActionBox<A: Action>: AnyAction, AnyActionBox, CustomStringConvertible, MainThreadChecking {

    let action: A

    var nestedActionHelper: NestedActionHelper?

    init(_ action: A) {
        self.action = action
    }

    func perform(with viewController: UIViewController, on existingController: UIViewController, animated: Bool, completion: @escaping (ActionResult) -> Void) {
        guard let typedExistingViewController = existingController as? A.ViewController else {
            completion(.failure(RoutingError.typeMismatch(ActionType.ViewController.self, RoutingError.Context("Action \(action.self) cannot " +
                    "be performed on \(existingController)."))))
            return
        }
        assertIfNotMainThread()
        if let nestedActionHelper = nestedActionHelper {
            nestedActionHelper.purge(animated: animated, completion: {
                action.perform(with: viewController, on: typedExistingViewController, animated: animated) { result in
                    self.assertIfNotMainThread()
                    completion(result)
                }
            })
            return
        }
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

    func isEmbeddable(to container: ContainerViewController.Type) -> Bool {
        return false
    }

}

class ContainerActionBox<A: ContainerAction>: AnyAction, AnyActionBox, CustomStringConvertible, MainThreadChecking {

    let action: A

    var nestedActionHelper: NestedActionHelper?

    required init(_ action: A) {
        self.action = action
    }

    func perform(with viewController: UIViewController, on existingController: UIViewController, animated: Bool, completion: @escaping (ActionResult) -> Void) {
        if let nestedActionHelper = nestedActionHelper {
            try? action.perform(embedding: viewController, in: &nestedActionHelper.viewControllers)
            completion(.continueRouting)
            return
        }
        guard let containerController: A.ViewController = UIViewController.findContainer(of: existingController) else {
            completion(.failure(RoutingError.typeMismatch(ActionType.ViewController.self, RoutingError.Context("Container of " +
                    "\(String(describing: ActionType.ViewController.self)) type cannot be found to perform \(action)"))))
            return
        }
        assertIfNotMainThread()
        let nestedActionHelper1 = NestedActionHelper(containerViewController: containerController)
        self.nestedActionHelper = nestedActionHelper1
        try? action.perform(embedding: viewController, in: &nestedActionHelper1.viewControllers)
        completion(.continueRouting)
//        action.perform(with: viewController, on: containerController, animated: animated) { result in
//            self.assertIfNotMainThread()
//            completion(result)
//        }
    }

    func perform(embedding viewController: UIViewController, in childViewControllers: inout [UIViewController]) throws {
        try action.perform(embedding: viewController, in: &childViewControllers)
    }

    public var description: String {
        return String(describing: action)
    }

    func isEmbeddable(to container: ContainerViewController.Type) -> Bool {
        return container is A.ViewController.Type
    }

}

class NestedActionHelper {

    var viewControllers: [UIViewController] = []

    var containerViewController: ContainerViewController

    init(containerViewController: ContainerViewController) {
        self.containerViewController = containerViewController
        self.viewControllers = containerViewController.containedViewControllers
    }

    func purge(animated: Bool, completion: () -> Void) {
        containerViewController.replace(containedViewControllers: viewControllers, animated: animated, completion: completion)
    }

}
