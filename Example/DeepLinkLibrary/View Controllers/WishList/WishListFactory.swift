//
// Created by Eugene Kazaev on 08/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

class WishListFactory: Factory {

    typealias ViewController = WishListViewController

    typealias Context = WishListContext

    let action: Action

    var context: Context = WishListContext(content: .favorites)

    init(action: Action) {
        self.action = action
    }

    func prepare(with context: Context?, logger: Logger?) -> RoutingResult {
        guard let context = context else {
            return .unhandled
        }
        self.context = context
        return .handled
    }

    func build(logger: Logger?) -> ViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "WishListViewController") as? ViewController else {
            return nil
        }
        viewController.content = context.content
        return viewController
    }

}
