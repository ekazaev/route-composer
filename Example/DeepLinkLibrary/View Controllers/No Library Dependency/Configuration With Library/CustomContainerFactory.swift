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

    var factories: [AnyFactory] = []

    let action: Action

    let delegate: CustomViewControllerDelegate

    init(delegate: CustomViewControllerDelegate, action: Action) {
        self.action = action
        self.delegate = delegate
    }

    func build(with context: Context?) -> FactoryBuildResult {
        guard let containerController = UIStoryboard(name: "Images", bundle: nil)
                .instantiateViewController(withIdentifier: "CustomContainerController") as? ViewController else {
            return .failure("Could not load CustomContainerController from storyboard.")
        }
        containerController.delegate = delegate

        // Our custom view controller can present only one child. So we have to create only last one if it exist.
        if let childFactory = factories.last, case let .success(viewController) = childFactory.build(with: context) {
            containerController.rootViewController = viewController
        }
        return .success(containerController)
    }

}

extension CustomContainerController: ContainerViewController {

    func makeVisible(viewController: UIViewController, animated: Bool) {

    }

    var canBeDismissed: Bool {
        guard let routingSupportController = rootViewController as? RoutingRuleSupportViewController else {
            return true
        }
        return routingSupportController.canBeDismissed
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
