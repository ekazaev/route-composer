//
// Created by Eugene Kazaev on 16/01/2018.
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

        if self.navigationController?.viewControllers.count == 1 {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
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
        self.dismiss(animated: true)
    }

    private func reloadData() {
        guard isViewLoaded else {
            return
        }

        productIdLabel.text = productId
        if let productId = productId {
            self.view.accessibilityIdentifier = "productViewController+\(productId)"
            self.title = "Product \(productId)"
        } else {
            self.view.accessibilityIdentifier = "productViewController"
            self.title = "Product"
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

    @IBAction func goToProductFromCircleTapped() {
        guard let productId = productId,
              var productIdAsInt = Int(productId) else {
            return
        }
        productIdAsInt = productIdAsInt < 9 ? productIdAsInt + 1 : 0
        try? router.navigate(to: ProductConfiguration.productScreenFromCircle, with: ProductContext(productId: "0\(productIdAsInt)"))
    }

}

extension ProductViewController: ContextChecking {

    func isTarget(for context: ProductContext) -> Bool {
        return self.productId == context.productId
    }

}
