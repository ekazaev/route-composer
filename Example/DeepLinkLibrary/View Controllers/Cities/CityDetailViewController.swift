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
        guard let _ = viewController as? CityDetailViewController else {
            return false
        }

        return true
    }

}

class CityDetailsViewControllerFactory: Factory {

    let action: ViewControllerAction?

    var cityId: Int?

    init(action: ViewControllerAction? = nil) {
        self.action = action
    }

    func build() -> UIViewController? {
        return UIStoryboard(name: "Split", bundle: nil).instantiateViewController(withIdentifier: "CityDetailViewController")
    }

}

class CityDetailPostTask: PostRoutingTask {

    func execute(on viewController: UIViewController, with arguments: Any?) {
        guard let viewController = viewController as? CityDetailViewController,
              let arguments = arguments as? CityArguments,
              let destinationCityId = arguments.cityId else {
            return
        }

        viewController.cityId = destinationCityId
    }

}

class CityDetailViewController: UIViewController, AnalyticsSupportViewController {

    let  analyticParameters = ExampleAnalyticsParameters(source: .cityDetail)

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
        DefaultRouter().deepLinkTo(destination: CitiesConfiguration.citiesList(cityId: nil))
    }
}
