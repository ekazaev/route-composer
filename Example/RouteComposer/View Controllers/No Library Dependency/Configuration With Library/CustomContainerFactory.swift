//
// Created by Eugene Kazaev on 25/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer
import ContainerViewController

class CustomContainerFactory: SimpleContainer {

    typealias SupportedAction = ReplaceRoot

    typealias ViewController = CustomContainerController

    typealias Context = Any?

    weak var delegate: CustomViewControllerDelegate?

    init(delegate: CustomViewControllerDelegate) {
        self.delegate = delegate
    }

    func build(with context: Context, integrating viewControllers: [UIViewController]) throws -> ViewController {
        guard let containerController = UIStoryboard(name: "Images", bundle: Bundle.main)
                .instantiateViewController(withIdentifier: "CustomContainerController") as? ViewController else {
            throw RoutingError.message("Could not load CustomContainerController from storyboard.")
        }
        containerController.delegate = delegate

        // Our custom view controller can present only one child. So we will use only the last one if it exist.
        containerController.rootViewController = viewControllers.last
        return containerController
    }

}

extension CustomContainerController: ContainerViewController {

    public var containingViewControllers: [UIViewController] {
        guard let rootViewController = rootViewController else {
            return []
        }
        return [rootViewController]
    }

    public var visibleViewControllers: [UIViewController] {
        return containingViewControllers
    }

    public func makeVisible(_ viewController: UIViewController, animated: Bool) {

    }

    public var canBeDismissed: Bool {
        return containingViewControllers.canBeDismissed
    }

}

extension CustomContainerFactory {

    struct ReplaceRoot: Action {

        func perform(with viewController: UIViewController, on existingController: UIViewController, animated: Bool, completion: @escaping (_: ActionResult) -> Void) {
            guard let customContainerController = existingController as? CustomContainerController else {
                completion(.failure("\(existingController) is not CustomContainerController"))
                return
            }

            customContainerController.rootViewController = viewController
            completion(.continueRouting)
        }

    }

}
