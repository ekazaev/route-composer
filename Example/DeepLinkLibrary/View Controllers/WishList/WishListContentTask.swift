//
// Created by Eugene Kazaev on 08/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

class WishListContentTask: ContextTask {

    typealias ViewController = WishListViewController

    typealias Context = WishListContext

    func apply(on viewController: WishListViewController, with context: WishListContext?) {
        guard let content = context?.content else {
            viewController.content = .favorites
            return
        }
        viewController.content = content
    }

}
