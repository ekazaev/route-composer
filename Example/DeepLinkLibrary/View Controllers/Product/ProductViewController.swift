//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

class ProductViewControllerFinder: FinderWithPolicy {

    let policy: FinderPolicy

    init(policy: FinderPolicy = .allStackUp) {
        self.policy = policy
    }

    func isTarget(viewController: UIViewController, arguments: Any?) -> Bool {
        guard let controller = viewController as? ProductViewController,
              let arguments = arguments as? ProductArguments,
              let controllerProductId = controller.productId,
              controllerProductId == arguments.productId else {
            return false
        }
        controller.productId = arguments.productId
        return true
    }

}

class ProductViewControllerFactory: Factory, PreparableFactory {

    let action: ViewControllerAction?

    var arguments: ProductArguments?

    init(action: ViewControllerAction? = nil) {
        self.action = action
    }

    func build(with logger: Logger?) -> UIViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ProductViewController") as? ProductViewController else {
            return nil
        }

        viewController.productId = arguments?.productId

        return viewController
    }

    func prepare(with arguments: Any?) -> DeepLinkResult {
        guard let arguments = arguments as? ProductArguments else {
            return .unhandled
        }

        self.arguments = arguments
        return .handled
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
        router.deepLinkTo(destination: ExampleConfiguration.destination(for: ExampleSource.circle)!)
    }

    @IBAction func goToSplitTapped() {
        router.deepLinkTo(destination: CitiesConfiguration.citiesList())
    }

    @IBAction func goToProductTapped() {
        router.deepLinkTo(destination: ProductConfiguration.productDestination(productId: "01"))
    }

}
