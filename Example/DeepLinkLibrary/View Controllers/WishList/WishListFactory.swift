//
// Created by Eugene Kazaev on 08/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

class WishListFactory: MandatoryContextFactory {

    typealias ViewController = WishListViewController

    typealias Context = WishListContext

    let action: Action

    init(action: Action) {
        self.action = action
    }

    func build(with context: Context) throws -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "WishListViewController") as? ViewController else {
            throw RoutingError.message("Unable to load WishListViewController")
        }
        viewController.content = context.content
        return viewController
    }

}
