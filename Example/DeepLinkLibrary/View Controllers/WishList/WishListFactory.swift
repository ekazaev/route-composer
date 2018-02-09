//
// Created by Eugene Kazaev on 08/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

class WishListFactory: Factory {

    let action: Action

    var arguments: WishListArguments = WishListArguments(content: .favorites)

    init(action: Action) {
        self.action = action
    }

    func prepare(with arguments: Any?) -> RoutingResult {
        guard let arguments = arguments as? WishListArguments else {
            return .unhandled
        }
        self.arguments = arguments
        return .handled
    }

    func build(with logger: Logger?) -> UIViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "WishListViewController") as? WishListViewController else {
            return nil
        }
        viewController.content = arguments.content
        return viewController
    }

}