//
// Created by Eugene Kazaev on 08/02/2018.
//

import Foundation
import RouteComposer
import UIKit

class WishListContextTask: ContextTask {

    func perform(on viewController: WishListViewController, with context: WishListContext) throws {
        viewController.context = context
    }

}
