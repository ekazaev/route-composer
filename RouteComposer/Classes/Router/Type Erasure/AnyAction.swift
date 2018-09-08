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

struct ActionBox<A: Action>: AnyAction {

    let action: A

    init(_ action: A) {
        self.action = action
    }

    let embeddable: Bool = false

    func perform(with viewController: UIViewController, on existingController: UIViewController, animated: Bool, completion: @escaping (ActionResult) -> Void) {
        guard let typedExistingViewController = existingController as? A.ViewController else {
            completion(.failure("Action \(action) can not be performed from \(existingController)."))
            return
        }
        action.perform(with: viewController, on: typedExistingViewController, animated: animated, completion: completion)
    }

    func perform(embedding viewController: UIViewController, in childViewControllers: inout [UIViewController]) {
        childViewControllers.append(viewController)
    }

}

struct ContainerActionBox<A: ContainerAction>: AnyAction {

    let action: A

    init(_ action: A) {
        self.action = action
    }

    let embeddable: Bool = true

    func perform(with viewController: UIViewController, on existingController: UIViewController, animated: Bool, completion: @escaping (ActionResult) -> Void) {
        guard let containerController = findContainer(startingFrom: existingController) else {
            completion(.failure("Container of the appropriate type can not be found to perform \(action)"))
            return
        }

        action.perform(with: viewController, on: containerController, animated: animated, completion: completion)
    }

    func perform(embedding viewController: UIViewController, in childViewControllers: inout [UIViewController]) {
        action.perform(embedding: viewController, in: &childViewControllers)
    }

    private func findContainer(startingFrom viewController: UIViewController) -> A.SupportedContainer.ViewController? {
        var currentViewController: UIViewController? = viewController
        while currentViewController != nil {
            if let containerViewController = currentViewController as? A.SupportedContainer.ViewController {
                return containerViewController
            }
            currentViewController = currentViewController?.parent
        }
        return nil
    }

}
