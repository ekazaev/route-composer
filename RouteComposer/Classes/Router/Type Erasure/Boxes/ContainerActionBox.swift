//
// Created by Eugene Kazaev on 2019-02-27.
//

import Foundation

struct ContainerActionBox<A: ContainerAction>: AnyAction, AnyActionBox, CustomStringConvertible, MainThreadChecking {

    let action: A

    init(_ action: A) {
        self.action = action
    }

    func perform(with viewController: UIViewController,
                 on existingController: UIViewController,
                 with postponedIntegrationHandler: PostponedActionIntegrationHandler,
                 nextAction: AnyAction?,
                 animated: Bool,
                 completion: @escaping (ActionResult) -> Void) throws {
        assertIfNotMainThread()
        if let postponedController = postponedIntegrationHandler.containerViewController {
            guard postponedController is A.ViewController else {
                try postponedIntegrationHandler.purge(animated: animated, completion: {
                    do {
                        try self.perform(with: viewController,
                                on: existingController,
                                with: postponedIntegrationHandler,
                                nextAction: nextAction,
                                animated: animated,
                                completion: completion)

                    } catch let error {
                        completion(.failure(error))
                    }
                })
                return
            }
            embed(viewController: viewController, with: postponedIntegrationHandler, completion: completion)
        } else {
            guard let containerController: A.ViewController = UIViewController.findContainer(of: existingController) else {
                completion(.failure(RoutingError.typeMismatch(ActionType.ViewController.self, .init("Container of " +
                        "\(String(describing: ActionType.ViewController.self)) type cannot be found in the parents of " +
                        "\(String(describing: existingController)) to perform \(action)"))))
                return
            }
            let shouldDelayPerforming = nextAction?.isEmbeddable(to: A.ViewController.self) ?? false
            if shouldDelayPerforming {
                try postponedIntegrationHandler.update(containerViewController: containerController, animated: animated, completion: { result in
                    if case let .failure(error) = result {
                        completion(.failure(error))
                    } else {
                        self.embed(viewController: viewController, with: postponedIntegrationHandler, completion: completion)
                    }
                })
            } else {
                try postponedIntegrationHandler.purge(animated: animated, completion: {
                    self.action.perform(with: viewController, on: containerController, animated: animated) { result in
                        self.assertIfNotMainThread()
                        completion(result)
                    }
                })
            }
        }
    }

    private func embed(viewController: UIViewController, with postponedIntegrationHandler: PostponedActionIntegrationHandler, completion: @escaping (ActionResult) -> Void) {
        do {
            var postponedChildControllers = postponedIntegrationHandler.postponedViewControllers
            try perform(embedding: viewController, in: &postponedChildControllers)
            postponedIntegrationHandler.update(postponedViewControllers: postponedChildControllers)
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
