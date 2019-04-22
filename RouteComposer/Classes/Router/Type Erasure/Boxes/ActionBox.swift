//
// Created by Eugene Kazaev on 2019-02-27.
//

import Foundation

struct ActionBox<A: Action>: AnyAction, AnyActionBox, CustomStringConvertible, MainThreadChecking {

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
        guard let typedExistingViewController = existingController as? A.ViewController else {
            completion(.failure(RoutingError.typeMismatch(ActionType.ViewController.self, .init("Action \(action.self) cannot " +
                    "be performed on \(existingController)."))))
            return
        }
        assertIfNotMainThread()
        try postponedIntegrationHandler.purge(animated: animated, completion: {
            self.action.perform(with: viewController, on: typedExistingViewController, animated: animated) { result in
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
