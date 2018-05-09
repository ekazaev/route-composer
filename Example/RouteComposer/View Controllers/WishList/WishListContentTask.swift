//
// Created by Eugene Kazaev on 08/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer

class WishListContentTask: ContextTask {

    func apply(on viewController: WishListViewController, with context: WishListContent) {
        viewController.content = context
    }

}
