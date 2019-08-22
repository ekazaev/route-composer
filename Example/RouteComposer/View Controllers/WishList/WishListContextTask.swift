//
// Created by Eugene Kazaev on 08/02/2018.
//

import Foundation
import UIKit
import RouteComposer

class WishListContextTask: ContextTask {

    func perform(on viewController: WishListViewController, with context: WishListContext) throws {
        viewController.context = context
    }

}
