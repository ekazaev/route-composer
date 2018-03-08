//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

class CityDetailContextTask: ContextTask {

    func apply(on viewController: CityDetailViewController, with context: Int) {
        viewController.cityId = context
    }

}

class CityDetailViewController: UIViewController, ExampleAnalyticsSupport {

    let analyticParameters = ExampleAnalyticsParameters(source: .cityDetail)

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
        if let cityId = cityId {
            self.view.accessibilityIdentifier = "cityDetailsViewController+\(cityId)"
        } else {
            self.view.accessibilityIdentifier = "cityDetailsViewController"
        }
    }

    @IBAction func goToStarTapped() {
        router.deepLinkTo(destination: ExampleConfiguration.destination(for: ExampleTarget.star)!)
    }

    @IBAction func backProgrammaticallyTapped() {
        router.deepLinkTo(destination: CitiesConfiguration.citiesList(cityId: nil))
    }
}
