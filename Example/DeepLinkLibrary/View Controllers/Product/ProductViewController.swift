//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

class ProductViewControllerFinder: FinderWithPolicy {
    public typealias V = ProductViewController
    public typealias A = ProductArguments

    let policy: FinderPolicy

    init(policy: FinderPolicy = .allStackUp) {
        self.policy = policy
    }

    func isTarget(viewController: V, arguments: A?) -> Bool {
        guard let arguments = arguments,
              let controllerProductId = viewController.productId,
              controllerProductId == arguments.productId else {
            return false
        }
        viewController.productId = arguments.productId
        return true
    }

}

class ProductViewControllerFactory: ArgumentSavingFactory {
    public typealias V = ProductViewController
    public typealias A = ProductArguments

    let action: Action

    var arguments: A?

    init(action: Action) {
        self.action = action
    }

    func build(with logger: Logger?) -> V? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ProductViewController") as? V else {
            return nil
        }

        viewController.productId = arguments?.productId

        return viewController
    }

}

class ProductViewController: UIViewController, AnalyticsSupportViewController {

    let  analyticParameters = ExampleAnalyticsParameters(source: .product)

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
