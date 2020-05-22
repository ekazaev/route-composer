//
// RouteComposer
// CityDetailViewController.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2020.
// Distributed under the MIT license.
//

import Foundation
import RouteComposer
import UIKit

class CityDetailContextTask: ContextTask {

    func perform(on viewController: CityDetailViewController, with context: Int) throws {
        viewController.cityId = context
    }

}

class CityDetailViewController: UIViewController, ExampleAnalyticsSupport {

    let screenType = ExampleScreenTypes.cityDetail

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
        title = "\(city.city)"

        detailsTextView.text = city.city + "\n\n" + city.description
        if let cityId = cityId {
            view.accessibilityIdentifier = "cityDetailsViewController+\(cityId)"
        } else {
            view.accessibilityIdentifier = "cityDetailsViewController"
        }
    }

    @IBAction func goToStarTapped() {
        try? router.navigate(to: ConfigurationHolder.configuration.starScreen, with: "Test Context")
    }

    @IBAction func backProgrammaticallyTapped() {
        try? router.navigate(to: CitiesConfiguration.citiesList(cityId: nil))
    }

}
