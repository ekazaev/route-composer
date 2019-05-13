//
// Created by Eugene Kazaev on 25/02/2018.
// Copyright (c) 2018 HBC Digital. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer
import ContainerViewController

class CustomContainerFactory<C>: SimpleContainerFactory {

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

extension CustomContainerController: CustomContainerViewController {

    public var adapter: ContainerAdapter {
        return CustomContainerControllerAdapter(with: self)
    }

    public var canBeDismissed: Bool {
        return (rootViewController as? RoutingInterceptable)?.canBeDismissed ?? true
    }

}

extension CustomContainerFactory {

    struct ReplaceRoot: ContainerAction {

        func perform(with viewController: UIViewController,
                     on customContainerController: CustomContainerController,
                     animated: Bool,
                     completion: @escaping (_: ActionResult) -> Void) {
            customContainerController.rootViewController = viewController
            completion(.continueRouting)
        }

    }

}

// NB: Do not forget to register new container adapter in the `ContainerAdapterRegistry`
struct CustomContainerControllerAdapter: ConcreteContainerAdapter {

    private let customContainerController: CustomContainerController

    init(with customContainerController: CustomContainerController) {
        self.customContainerController = customContainerController
    }

    public var containedViewControllers: [UIViewController] {
        guard let rootViewController = customContainerController.rootViewController else {
            return []
        }
        return [rootViewController]
    }

    public var visibleViewControllers: [UIViewController] {
        return containedViewControllers
    }

    public func makeVisible(_ viewController: UIViewController, animated: Bool) throws {
        guard customContainerController.rootViewController != viewController else {
            throw RoutingError.compositionFailed(.init("\(customContainerController) does not contain \(viewController)"))
        }
    }

    public func setContainedViewControllers(_ containedViewControllers: [UIViewController], animated: Bool, completion: @escaping () -> Void) {
        customContainerController.rootViewController = containedViewControllers.last
        completion()
    }

}
