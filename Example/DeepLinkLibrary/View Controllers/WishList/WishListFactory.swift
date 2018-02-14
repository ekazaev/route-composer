//
// Created by Eugene Kazaev on 08/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

class WishListFactory: Factory {
    public typealias V = WishListViewController
    public typealias A = WishListArguments

    let action: Action

    var arguments: A = WishListArguments(content: .favorites)

    init(action: Action) {
        self.action = action
    }

    func prepare(with arguments: A?, logger: Logger?) -> RoutingResult {
        guard let arguments = arguments else {
            return .unhandled
        }
        self.arguments = arguments
        return .handled
    }

    func build(with logger: Logger?) -> V? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "WishListViewController") as? V else {
            return nil
        }
        viewController.content = arguments.content
        return viewController
    }

}
