//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

class CityDetailsViewControllerFinder: FinderWithPolicy {

    let policy: FinderPolicy

    init(policy: FinderPolicy = .allStack) {
        self.policy = policy
    }

    func isTarget(viewController: UIViewController, arguments: Any?) -> Bool {
        guard let viewController = viewController as? CityDetailViewController,
              let arguments = arguments as? ExampleTargetArguments,
              let destinationCityId = arguments[Argument.cityId] as? Int else {
            return false
        }

        viewController.cityId = destinationCityId

        return true
    }

}

class CityDetailsViewControllerFactory: Factory, PreparableFactory {

    let action: ViewControllerAction?

    var cityId: Int?

    init(action: ViewControllerAction? = nil) {
        self.action = action
    }

    func build() -> UIViewController? {
        guard let viewController = UIStoryboard(name: "Split", bundle: nil).instantiateViewController(withIdentifier: "CityDetailViewController") as? CityDetailViewController else {
            return nil
        }
        viewController.cityId = cityId

        return viewController
    }

    func prepare(with arguments: Any?) -> DeepLinkResult {
        guard let argumetns = arguments as? ExampleTargetArguments,
              let cityId = argumetns[Argument.cityId] as? Int else {
            return .unhandled
        }

        self.cityId = cityId
        return .handled
    }
}

class CityDetailViewController: UIViewController {

    @IBOutlet private var detailsTextView: UITextView!

    var cityId: Int? {
        didSet {
            reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
    }

    private func reloadData() {
        guard isViewLoaded, let city = CitiesDataModel.cities.first(where: { $0.cityId == cityId }) else {
            return
        }

        detailsTextView.text = city.city + "\n\n" + city.description
    }

    @IBAction func backProgrammaticalyTapped() {
        DefaultRouter().deepLinkTo(destination: configuration.destination(for: ExampleTarget.citiesList)!)
    }
}
