//
// RouteComposer
// ActionBox.swift
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
                 completion: @escaping (RoutingResult) -> Void) {
        guard let typedExistingViewController = existingController as? A.ViewController else {
            completion(.failure(RoutingError.typeMismatch(type: type(of: existingController),
                                                          expectedType: ActionType.ViewController.self,
                                                          .init("Action \(action.self) cannot be performed on \(existingController)."))))
            return
        }
        assertIfNotMainThread()
        postponedIntegrationHandler.purge(animated: animated, completion: { result in
            guard result.isSuccessful else {
                completion(result)
                return
            }
            action.perform(with: viewController, on: typedExistingViewController, animated: animated) { result in
                assertIfNotMainThread()
                completion(result)
            }
        })
    }

    func perform(embedding viewController: UIViewController, in childViewControllers: inout [UIViewController]) {
        childViewControllers.append(viewController)
    }

    public var description: String {
        String(describing: action)
    }

    func isEmbeddable(to container: ContainerViewController.Type) -> Bool {
        false
    }

}
