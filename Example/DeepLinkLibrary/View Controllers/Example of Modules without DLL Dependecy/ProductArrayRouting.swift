//
// Created by Eugene Kazaev on 09/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

class ProductArrayFinder: FinderWithPolicy {

    typealias ViewController = ProductArrayViewController

    typealias Context = ProductArrayContext

    let policy: FinderPolicy

    init(policy: FinderPolicy = .currentLevel) {
        self.policy = policy
    }

    func isTarget(viewController: ViewController, context: Context?) -> Bool {
        guard let viewControllerCategoryId = viewController.categoryId,
              let categoryId = context?.categoryId else {
            return false
        }
        return viewControllerCategoryId == categoryId
    }
}

class ProductArrayFactory: ContextSavingFactory {

    typealias ViewController = ProductArrayViewController

    typealias Context = ProductArrayContext

    let action: Action

    var context: Context?

    let fetcher: ProductArrayProductFetching

    init(fetcher: ProductArrayProductFetching, action: Action) {
        self.action = action
        self.fetcher = fetcher
    }

    func build(logger: Logger?) -> ViewController? {
        let storyboard = UIStoryboard(name: "ProductArray", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() as? ViewController else {
            return nil
        }
        viewController.fetcher = fetcher
        viewController.categoryId = context?.categoryId
        return viewController
    }

}