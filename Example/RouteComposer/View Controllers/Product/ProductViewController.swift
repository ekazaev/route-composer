//
// RouteComposer
// ProductViewController.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import RouteComposer
import UIKit

struct ProductContext {

    let productId: String

    let productURL: URL?

    init(productId: String, productURL: URL? = nil) {
        self.productId = productId
        self.productURL = productURL
    }
}

class ProductViewController: UIViewController, ExampleAnalyticsSupport, ContextAccepting {

    let screenType = ExampleScreenTypes.product

    typealias Model = String

    private(set) var productId: Model? {
        didSet {
            reloadData()
        }
    }

    @IBOutlet private var productIdLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()

        if navigationController?.viewControllers.count == 1 {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        }
    }

    func setup(with context: ProductContext) throws {
        productId = context.productId
    }

    class func checkCompatibility(with context: Context) throws {
        if context.productId.isEmpty {
            throw RoutingError.generic(.init("ProductId can not be empty."))
        }
    }

    @objc func doneTapped() {
        dismiss(animated: true)
    }

    private func reloadData() {
        guard isViewLoaded else {
            return
        }

        productIdLabel.text = productId
        if let productId {
            view.accessibilityIdentifier = "productViewController+\(productId)"
            title = "Product \(productId)"
        } else {
            view.accessibilityIdentifier = "productViewController"
            title = "Product"
        }
    }

    @IBAction func goToCircleTapped() {
        try? router.navigate(to: ConfigurationHolder.configuration.circleScreen, with: nil)
    }

    @IBAction func goToSplitTapped() {
        try? router.navigate(to: CitiesConfiguration.citiesList())
    }

    @IBAction func goToProductTapped() {
        try? router.navigate(to: ProductConfiguration.productScreen, with: ProductContext(productId: "01"))
    }

    @IBAction func goToSwiftUITapped() {
        try? router.navigate(to: ConfigurationHolder.configuration.swiftUIScreen, with: "RouteComposer")
    }

    @IBAction func goToProductFromCircleTapped() {
        guard let productId,
              var productIdAsInt = Int(productId) else {
            return
        }
        productIdAsInt = productIdAsInt < 9 ? productIdAsInt + 1 : 0
        try? router.navigate(to: ProductConfiguration.productScreenFromCircle, with: ProductContext(productId: "0\(productIdAsInt)"))
    }

    @IBAction func goHome() {
        try? router.navigate(to: InternalSearchConfiguration.home)
    }

    @IBAction func goSettings() {
        try? router.navigate(to: InternalSearchConfiguration.settings)
    }

}

extension ProductViewController: ContextChecking {

    func isTarget(for context: ProductContext) -> Bool {
        productId == context.productId
    }

}
