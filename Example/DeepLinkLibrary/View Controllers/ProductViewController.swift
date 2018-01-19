//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

class ProductViewControllerFinder: FinderWithPolicy {

    let policy: FinderPolicy

    init(policy: FinderPolicy = .allStack) {
        self.policy = policy
    }

    func isTarget(viewController: UIViewController, arguments: Any?) -> Bool {
        guard let controller = viewController as? ProductViewController,
              let arguments = arguments as? ExampleDictionaryArguments,
              let destinationModel = arguments[Argument.productId] as? ProductViewController.Model,
              let controllerModel = controller.model,
              destinationModel == controllerModel  else {
            return false
        }
        controller.model = destinationModel
        return true
    }

}

class ProductViewControllerFactory: Factory, PreparableFactory {

    let action: ViewControllerAction?

    var model: ProductViewController.Model?

    init(action: ViewControllerAction? = nil) {
        self.action = action
    }

    func build() -> UIViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ProductViewController") as? ProductViewController else {
            return nil
        }

        viewController.model = model

        return viewController
    }

    func prepare(with arguments: Any?) -> DeepLinkResult {
        guard let argumetns = arguments as? ExampleDictionaryArguments,
              let destinationModel = argumetns[Argument.productId] as? ProductViewController.Model else {
            return .unhandled
        }

        self.model = destinationModel
        return .handled
    }
}


class ProductViewController: UIViewController, AnalyticsSupportViewController {

    let  analyticParameters = ExampleAnalyticsParameters(source: .product)

    typealias Model = String

    var model: Model? {
        didSet {
            reloadData()
        }
    }

    @IBOutlet private var productIdLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
    }

    private func reloadData() {
        guard isViewLoaded else {
            return
        }

        productIdLabel.text = model
    }

    @IBAction func goToCircleTapped() {
        DefaultRouter().deepLinkTo(destination: configuration.destination(for: ExampleSource.circle)!)
    }

    @IBAction func goToSplitTapped() {
        DefaultRouter().deepLinkTo(destination: CitiesConfiguration.citiesList())
    }

    @IBAction func goToProductTapped() {
        DefaultRouter().deepLinkTo(destination: configuration.destination(for: ExampleSource.product, arguments: ExampleDictionaryArguments(arguments: [Argument.productId: "01"]))!)
    }

}
