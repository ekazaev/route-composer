//
// Created by Eugene Kazaev on 08/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

class WishListFactory: ContextSavingFactory {

    typealias ViewController = WishListViewController

    typealias Context = WishListContext

    let action: Action

    var context: Context? = WishListContext(content: .favorites)

    init(action: Action) {
        self.action = action
    }

    func build() -> FactoryBuildResult {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "WishListViewController") as? ViewController,
              let context = context else {
            return .failure(nil)
        }
        viewController.content = context.content
        return .success(viewController)
    }

}
