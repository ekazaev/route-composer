//
// Created by Eugene Kazaev on 08/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

class FakeContainerFactory: PreparableFactory {

    let action: ViewControllerAction

    var arguments: FakeContainerArguments = FakeContainerArguments(content: .favorites)

    init(action: ViewControllerAction) {
        self.action = action
    }

    func prepare(with arguments: Any?) -> DeepLinkResult {
        guard let arguments = arguments as? FakeContainerArguments else {
            return .unhandled
        }
        self.arguments = arguments
        return .handled
    }

    func build(with logger: Logger?) -> UIViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "FakeContainerViewController") as? FakeContainerViewController else {
            return nil
        }
        viewController.content = arguments.content
        return viewController
    }

}