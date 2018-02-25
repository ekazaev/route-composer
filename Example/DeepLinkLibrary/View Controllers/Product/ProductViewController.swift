//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

class ProductViewControllerFinder: FinderWithPolicy {

    typealias ViewController = ProductViewController

    typealias Context = ProductContext

    let policy: FinderPolicy

    init(policy: FinderPolicy = .allStackUp) {
        self.policy = policy
    }

    func isTarget(viewController: ViewController, context: Context?) -> Bool {
        guard let context = context,
              let controllerProductId = viewController.productId,
              controllerProductId == context.productId else {
            return false
        }
        viewController.productId = context.productId
        return true
    }

}

class ProductViewControllerFactory: MandatoryContextFactory {

    typealias ViewController = ProductViewController

    typealias Context = ProductContext

    let action: Action

    init(action: Action) {
        self.action = action
    }

    func build(with context: Context) -> FactoryBuildResult {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ProductViewController") as? ViewController else {
            return .failure(nil)
        }

        viewController.productId = context.productId

        return .success(viewController)
    }

}

class ProductViewController: UIViewController, AnalyticsSupportViewController {

    let analyticParameters = ExampleAnalyticsParameters(source: .product)

    typealias Model = String

    var productId: Model? {
        didSet {
            reloadData()
        }
    }

    @IBOutlet private var productIdLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()

        if self.navigationController?.viewControllers.count == 1 {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        }
    }

    @objc func doneTapped() {
        self.dismiss(animated: true)
    }

    private func reloadData() {
        guard isViewLoaded else {
            return
        }

        productIdLabel.text = productId
        if let productId = productId {
            self.view.accessibilityIdentifier = "productViewController+\(productId)"
        } else {
            self.view.accessibilityIdentifier = "productViewController"
        }
    }

    @IBAction func goToCircleTapped() {
        router.deepLinkTo(destination: ExampleConfiguration.destination(for: ExampleTarget.circle)!)
    }

    @IBAction func goToSplitTapped() {
        router.deepLinkTo(destination: CitiesConfiguration.citiesList())
    }

    @IBAction func goToProductTapped() {
        router.deepLinkTo(destination: ProductConfiguration.productDestination(productId: "01"))
    }

}
