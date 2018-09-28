//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer

struct ProductContext {

    let productId: String

    let productURL: URL?

    init(productId: String, productURL: URL? = nil) {
        self.productId = productId
        self.productURL = productURL
    }
}

class ProductContextTask: ContextTask {

    func apply(on viewController: ProductViewController, with context: ProductContext) throws {
        viewController.productId = context.productId
    }

}

class ProductViewController: UIViewController, ExampleAnalyticsSupport {

    let screenType = ExampleScreen.product

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
        router.navigate(to: ConfigurationHolder.configuration.circleScreen, with: nil)
    }

    @IBAction func goToSplitTapped() {
        router.navigate(to: CitiesConfiguration.citiesList())
    }

    @IBAction func goToProductTapped() {
        router.navigate(to: ProductConfiguration.productScreen, with: ProductContext(productId: "01"))
    }

}

extension ProductViewController: ContextChecking {

    func isTarget(for context: ProductContext) -> Bool {
        return self.productId == context.productId
    }

}
