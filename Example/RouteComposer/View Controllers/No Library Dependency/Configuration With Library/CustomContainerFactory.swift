//
// RouteComposer
// CustomContainerFactory.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import ContainerViewController
import Foundation
import RouteComposer
import UIKit

@MainActor class CustomContainerFactory<C>: SimpleContainerFactory {

    typealias ViewController = CustomContainerController

    typealias Context = C

    weak var delegate: CustomViewControllerDelegate?

    init(delegate: CustomViewControllerDelegate) {
        self.delegate = delegate
    }

    func build(with context: C, integrating viewControllers: [UIViewController]) throws -> CustomContainerController {
        guard let containerController = UIStoryboard(name: "Images", bundle: Bundle.main)
            .instantiateViewController(withIdentifier: "CustomContainerController") as? ViewController else {
            throw RoutingError.compositionFailed(.init("Could not load CustomContainerController from the storyboard."))
        }
        containerController.delegate = delegate

        // Our custom view controller can only present one child. So we will use only the last one if it exist.
        containerController.rootViewController = viewControllers.last
        return containerController
    }

}

extension CustomContainerController: @retroactive ContainerViewController {}
extension CustomContainerController: @retroactive RoutingInterceptable {}
extension CustomContainerController: @retroactive CustomContainerViewController {

    public var adapter: ContainerAdapter {
        CustomContainerControllerAdapter(with: self)
    }

    public var canBeDismissed: Bool {
        (rootViewController as? RoutingInterceptable)?.canBeDismissed ?? true
    }

}

extension CustomContainerFactory {

    struct ReplaceRoot: ContainerAction {

        func perform(with viewController: UIViewController,
                     on customContainerController: CustomContainerController,
                     animated: Bool,
                     completion: @escaping (_: RoutingResult) -> Void) {
            customContainerController.rootViewController = viewController
            completion(.success)
        }

    }

}

struct CustomContainerControllerAdapter: ConcreteContainerAdapter {

    private weak var customContainerController: CustomContainerController?

    init(with customContainerController: CustomContainerController) {
        self.customContainerController = customContainerController
    }

    public var containedViewControllers: [UIViewController] {
        guard let rootViewController = customContainerController?.rootViewController else {
            return []
        }
        return [rootViewController]
    }

    public var visibleViewControllers: [UIViewController] {
        containedViewControllers
    }

    public func makeVisible(_ viewController: UIViewController, animated: Bool, completion: @escaping (_: RoutingResult) -> Void) {
        guard let customContainerController else {
            completion(.failure(RoutingError.compositionFailed(.init("CustomContainerController has been deallocated"))))
            return
        }
        guard customContainerController.rootViewController != viewController else {
            completion(.failure(RoutingError.compositionFailed(.init("\(customContainerController) does not contain \(viewController)"))))
            return
        }
        completion(.success)
    }

    public func setContainedViewControllers(_ containedViewControllers: [UIViewController], animated: Bool, completion: @escaping (_: RoutingResult) -> Void) {
        guard let customContainerController else {
            completion(.failure(RoutingError.compositionFailed(.init("CustomContainerController has been deallocated"))))
            return
        }
        customContainerController.rootViewController = containedViewControllers.last
        completion(.success)
    }

}
