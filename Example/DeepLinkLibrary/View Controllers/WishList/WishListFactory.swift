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

    func build(with context: Context) -> FactoryBuildResult {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "WishListViewController") as? ViewController else {
            return .failure(nil)
        }
        viewController.content = context.content
        return .success(viewController)
    }

}
