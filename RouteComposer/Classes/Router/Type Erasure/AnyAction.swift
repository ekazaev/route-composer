//
// Created by Eugene Kazaev on 08/09/2018.
//

import Foundation
import UIKit

protocol DelayedActionIntegrationHandler: AnyObject {

    var containerViewController: ContainerViewController? { get }

    var delayedViewControllers: [UIViewController] { get }

    func update(containerViewController: ContainerViewController, animated: Bool, completion: () -> Void)

    func update(delayedViewControllers: [UIViewController])

    func purge(animated: Bool, completion: () -> Void)

}

protocol AnyAction {

    func perform(with viewController: UIViewController,
                 on existingController: UIViewController,
                 with delayedIntegrationHandler: DelayedActionIntegrationHandler,
                 nextAction: AnyAction?,
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

    init(_ action: A) {
        self.action = action
    }

    func perform(with viewController: UIViewController, on existingController: UIViewController, with delayedIntegrationHandler: DelayedActionIntegrationHandler, nextAction: AnyAction?, animated: Bool, completion: @escaping (ActionResult) -> Void) {
        guard let typedExistingViewController = existingController as? A.ViewController else {
            completion(.failure(RoutingError.typeMismatch(ActionType.ViewController.self, RoutingError.Context("Action \(action.self) cannot " +
                    "be performed on \(existingController)."))))
            return
        }
        assertIfNotMainThread()
        delayedIntegrationHandler.purge(animated: animated, completion: {
            action.perform(with: viewController, on: typedExistingViewController, animated: animated) { result in
                self.assertIfNotMainThread()
                completion(result)
            }
        })
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

struct ContainerActionBox<A: ContainerAction>: AnyAction, AnyActionBox, CustomStringConvertible, MainThreadChecking {

    let action: A

    init(_ action: A) {
        self.action = action
    }

    func perform(with viewController: UIViewController, on existingController: UIViewController, with delayedIntegrationHandler: DelayedActionIntegrationHandler, nextAction: AnyAction?, animated: Bool, completion: @escaping (ActionResult) -> Void) {
        assertIfNotMainThread()
        if let delayedController = delayedIntegrationHandler.containerViewController {
            guard delayedController is A.ViewController else {
                delayedIntegrationHandler.purge(animated: animated, completion: {
                    self.perform(with: viewController, on: existingController, with: delayedIntegrationHandler, nextAction: nextAction, animated: animated, completion: completion)
                })
                return
            }
            embed(viewController: viewController, with: delayedIntegrationHandler, completion: completion)
        } else {
            guard let containerController: A.ViewController = UIViewController.findContainer(of: existingController) else {
                completion(.failure(RoutingError.typeMismatch(ActionType.ViewController.self, RoutingError.Context("Container of " +
                        "\(String(describing: ActionType.ViewController.self)) type cannot be found to perform \(action)"))))
                return
            }
            let shouldDelayPerforming = nextAction?.isEmbeddable(to: A.ViewController.self) ?? false
            if shouldDelayPerforming {
                delayedIntegrationHandler.update(containerViewController: containerController, animated: animated, completion: {
                    self.embed(viewController: viewController, with: delayedIntegrationHandler, completion: completion)
                })
            } else {
                delayedIntegrationHandler.purge(animated: animated, completion: {
                    action.perform(with: viewController, on: containerController, animated: animated) { result in
                        self.assertIfNotMainThread()
                        completion(result)
                    }
                })
            }
        }
    }

    private func embed(viewController: UIViewController, with delayedIntegrationHandler: DelayedActionIntegrationHandler, completion: @escaping (ActionResult) -> Void) {
        do {
            var delayedChildControllers = delayedIntegrationHandler.delayedViewControllers
            try perform(embedding: viewController, in: &delayedChildControllers)
            delayedIntegrationHandler.update(delayedViewControllers: delayedChildControllers)
            completion(.continueRouting)
        } catch let error {
            completion(.failure(error))
        }
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
