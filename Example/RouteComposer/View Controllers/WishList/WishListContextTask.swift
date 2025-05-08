//
// RouteComposer
// WishListContextTask.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2025.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import RouteComposer
import UIKit

class WishListContextTask: ContextTask {

    func perform(on viewController: WishListViewController, with context: WishListContext) throws {
        viewController.context = context
    }

}
