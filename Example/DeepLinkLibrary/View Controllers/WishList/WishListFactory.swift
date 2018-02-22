//
// Created by Eugene Kazaev on 08/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

class WishListFactory: Factory {

    typealias V = WishListViewController

    typealias C = WishListContext

    let action: Action

    var context: C = WishListContext(content: .favorites)

    init(action: Action) {
        self.action = action
    }

    func prepare(with context: C?, logger: Logger?) -> RoutingResult {
        guard let context = context else {
            return .unhandled
        }
        self.context = context
        return .handled
    }

    func build(logger: Logger?) -> V? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "WishListViewController") as? V else {
            return nil
        }
        viewController.content = context.content
        return viewController
    }

}
