//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer

class ProductContentTask: ContextTask {

    func apply(on viewController: ProductViewController, with context: String) {
        viewController.productId = context
    }

}

class ProductViewController: UIViewController, ExampleAnalyticsSupport {

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

extension ProductViewController: ContextChecking {

    func isTarget(for productId: String) -> Bool {
        return self.productId == productId
    }

}