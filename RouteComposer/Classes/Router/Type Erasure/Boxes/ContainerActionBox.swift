//
// RouteComposer
// ContainerActionBox.swift
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
                 completion: @escaping (RoutingResult) -> Void) {
        assertIfNotMainThread()
        if let postponedController = postponedIntegrationHandler.containerViewController {
            guard postponedController is A.ViewController else {
                postponedIntegrationHandler.purge(animated: animated, completion: { result in
                    guard result.isSuccessful else {
                        completion(result)
                        return
                    }
                    perform(with: viewController,
                            on: existingController,
                            with: postponedIntegrationHandler,
                            nextAction: nextAction,
                            animated: animated,
                            completion: completion)
                })
                return
            }
            embed(viewController: viewController, with: postponedIntegrationHandler, completion: completion)
        } else {
            guard let containerController: A.ViewController = UIViewController.findContainer(of: existingController) else {
                completion(.failure(RoutingError.typeMismatch(type: type(of: existingController),
                                                              expectedType: ActionType.ViewController.self,
                                                              .init("Container of \(String(describing: ActionType.ViewController.self)) type cannot be found in the parents of " +
                                                                  "\(String(describing: existingController)) to perform \(action)"))))
                return
            }
            let shouldDelayPerforming = nextAction?.isEmbeddable(to: A.ViewController.self) ?? false
            if shouldDelayPerforming {
                postponedIntegrationHandler.update(containerViewController: containerController, animated: animated, completion: { result in
                    guard result.isSuccessful else {
                        completion(result)
                        return
                    }
                    embed(viewController: viewController, with: postponedIntegrationHandler, completion: completion)
                })
            } else {
                postponedIntegrationHandler.purge(animated: animated, completion: { result in
                    guard result.isSuccessful else {
                        completion(result)
                        return
                    }
                    action.perform(with: viewController, on: containerController, animated: animated) { result in
                        assertIfNotMainThread()
                        completion(result)
                    }
                })
            }
        }
    }

    private func embed(viewController: UIViewController, with postponedIntegrationHandler: PostponedActionIntegrationHandler, completion: @escaping (RoutingResult) -> Void) {
        do {
            var postponedChildControllers = postponedIntegrationHandler.postponedViewControllers
            try perform(embedding: viewController, in: &postponedChildControllers)
            postponedIntegrationHandler.update(postponedViewControllers: postponedChildControllers)
            completion(.success)
        } catch {
            completion(.failure(error))
        }
    }

    func perform(embedding viewController: UIViewController, in childViewControllers: inout [UIViewController]) throws {
        try action.perform(embedding: viewController, in: &childViewControllers)
    }

    public var description: String {
        String(describing: action)
    }

    func isEmbeddable(to container: ContainerViewController.Type) -> Bool {
        container is A.ViewController.Type
    }

}
