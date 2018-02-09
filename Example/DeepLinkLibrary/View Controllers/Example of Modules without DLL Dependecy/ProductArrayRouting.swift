//
// Created by Eugene Kazaev on 09/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

class ProductArrayFinder: FinderWithPolicy {

    public typealias V = ProductArrayViewController
    public typealias A = ProductArrayContext

    let policy: FinderPolicy

    init(policy: FinderPolicy = .currentLevel) {
        self.policy = policy
    }

    func isTarget(viewController: V, arguments: A?) -> Bool {
        guard let viewControllerCategoryId = viewController.categoryId,
              let categoryId = arguments?.categoryId else {
            return false
        }
        return viewControllerCategoryId == categoryId
    }
}

class ProductArrayFactory: ArgumentSavingFactory {

    public typealias V = ProductArrayViewController
    public typealias A = ProductArrayContext

    let action: Action

    var arguments: A?

    let fetcher: ProductArrayProductFetching

    init(fetcher: ProductArrayProductFetching, action: Action) {
        self.action = action
        self.fetcher = fetcher
    }

    func build(with logger: Logger?) -> V? {
        let storyboard = UIStoryboard(name: "ProductArray", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() as? V else {
            return nil
        }
        viewController.fetcher = fetcher
        viewController.categoryId = arguments?.categoryId
        return viewController
    }

}