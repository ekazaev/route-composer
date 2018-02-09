//
// Created by Eugene Kazaev on 09/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import DeepLinkLibrary
import UIKit

class PushChildCategoryAction: Action {

    func perform(viewController: UIViewController, on existingController: UIViewController, animated: Bool, logger: Logger?, completion: @escaping (ActionResult) -> Void) {
        guard let categoriesViewController = existingController as? CategoriesViewController else {
            return completion(.failure)
        }

        let currentViewController = categoriesViewController.childViewControllers.first
        currentViewController?.willMove(toParentViewController: nil)
        categoriesViewController.addChildViewController(viewController)
        categoriesViewController.containerView.addSubview(viewController.view)
        viewController.view.topAnchor.constraint(equalTo: categoriesViewController.containerView.topAnchor).isActive = true
        viewController.view.bottomAnchor.constraint(equalTo: categoriesViewController.containerView.bottomAnchor).isActive = true
        viewController.view.leftAnchor.constraint(equalTo: categoriesViewController.containerView.leftAnchor).isActive = true
        viewController.view.rightAnchor.constraint(equalTo: categoriesViewController.containerView.rightAnchor).isActive = true

        if let currentViewController = currentViewController {
            viewController.view.alpha = 0
            categoriesViewController.transition(from: currentViewController, to: viewController, duration: 0.2, options: [], animations: {
                viewController.view.alpha = 1
                currentViewController.view.alpha = 0
            }) { (_) in
                currentViewController.removeFromParentViewController()
                currentViewController.view.removeFromSuperview()
                viewController.didMove(toParentViewController: categoriesViewController)
                completion(.continueRouting)
            }
        } else {
            viewController.didMove(toParentViewController: categoriesViewController)
            completion(.continueRouting)
        }
    }

}

class CategoriesFinder: FinderWithPolicy {

    public typealias V = CategoriesViewController
    public typealias A = CategoriesContext

    let policy: FinderPolicy

    init(policy: FinderPolicy = .currentLevel) {
        self.policy = policy
    }

    func isTarget(viewController: V, arguments: A?) -> Bool {
        viewController.categoryId = arguments?.categoryId
        return true
    }
}

class CategoriesFactory: ArgumentSavingFactory {

    public typealias V = CategoriesViewController
    public typealias A = CategoriesContext

    let action: Action

    let fetcher: CategoriesFetching

    var arguments: A?

    weak var delegate: CategoriesViewControllerDelegate?

    init(delegate: CategoriesViewControllerDelegate, fetcher: CategoriesFetching, action: Action) {
        self.action = action
        self.fetcher = fetcher
        self.delegate = delegate
    }

    func build(with logger: Logger?) -> V? {
        guard let categoriesViewController = UIStoryboard(name: "Categories", bundle: nil).instantiateInitialViewController() as? V else {
            return nil
        }

        categoriesViewController.categoryId = arguments?.categoryId
        categoriesViewController.delegate = delegate
        categoriesViewController.fetcher = fetcher

        return categoriesViewController
    }

}