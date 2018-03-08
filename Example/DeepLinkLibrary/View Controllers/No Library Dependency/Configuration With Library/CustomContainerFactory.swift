//
// Created by Eugene Kazaev on 25/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

class CustomContainerFactory: SingleActionContainerFactory {

    typealias SupportedAction = CustomContainerChildAction

    typealias ViewController = CustomContainerController

    typealias Context = Any

    var factories: [ChildFactory<Context>] = []

    let action: Action

    let delegate: CustomViewControllerDelegate

    init(delegate: CustomViewControllerDelegate, action: Action) {
        self.action = action
        self.delegate = delegate
    }

    func build(with context: Context) throws -> ViewController {
        guard let containerController = UIStoryboard(name: "Images", bundle: nil)
                .instantiateViewController(withIdentifier: "CustomContainerController") as? ViewController else {
            throw RoutingError.message("Could not load CustomContainerController from storyboard.")
        }
        containerController.delegate = delegate

        // Our custom view controller can present only one child. So we will use only the last one if it exist.
        let viewControllers = try buildChildrenViewControllers(with: context)
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

    func makeVisible(viewController: UIViewController, animated: Bool) {

    }

    var canBeDismissed: Bool {
        return containingViewControllers.canBeDismissed
    }

}

class CustomContainerChildAction: Action {

    func perform(viewController: UIViewController, on existingController: UIViewController, animated: Bool, completion: @escaping (_: ActionResult) -> Void) {
        guard let customContainerController = existingController as? CustomContainerController else {
            completion(.failure("\(existingController) is not CustomContainerController"))
            return
        }

        customContainerController.rootViewController = viewController
        completion(.continueRouting)
    }

}
