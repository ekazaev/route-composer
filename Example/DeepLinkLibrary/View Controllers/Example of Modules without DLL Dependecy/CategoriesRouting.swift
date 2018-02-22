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

    public typealias ViewController = CategoriesViewController
    public typealias Context = CategoriesContext

    let policy: FinderPolicy

    init(policy: FinderPolicy = .currentLevel) {
        self.policy = policy
    }

    func isTarget(viewController: ViewController, context: Context?) -> Bool {
        viewController.categoryId = context?.categoryId
        return true
    }
}

class CategoriesFactory: ContextSavingFactory {

    public typealias ViewController = CategoriesViewController

    public typealias Context = CategoriesContext

    let action: Action

    let fetcher: CategoriesFetching

    var context: Context?

    weak var delegate: CategoriesViewControllerDelegate?

    init(delegate: CategoriesViewControllerDelegate, fetcher: CategoriesFetching, action: Action) {
        self.action = action
        self.fetcher = fetcher
        self.delegate = delegate
    }

    func build(logger: Logger?) -> ViewController? {
        guard let categoriesViewController = UIStoryboard(name: "Categories", bundle: nil).instantiateInitialViewController() as? ViewController else {
            return nil
        }

        categoriesViewController.categoryId = context?.categoryId
        categoriesViewController.delegate = delegate
        categoriesViewController.fetcher = fetcher

        return categoriesViewController
    }

}