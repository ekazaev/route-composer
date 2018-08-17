//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer

class CityTableContextTask: ContextTask {

    func apply(on viewController: CitiesTableViewController, with context: Int?) {
        viewController.cityId = context
    }

}


class CitiesTableViewController: UITableViewController, ExampleAnalyticsSupport {

    let analyticParameters = ExampleAnalyticsParameters(source: .citiesList)

    var cityId: Int? {
        didSet {
            guard let cityId = cityId else {
                return
            }
            let indexPath = IndexPath(row: cityId - 1, section: 0)

            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.splitViewController?.delegate = self
        self.splitViewController?.preferredDisplayMode = .allVisible
        self.splitViewController?.view.accessibilityIdentifier = "citiesSplitViewController"
        self.view.accessibilityIdentifier = "citiesViewController"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CitiesDataModel.cities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell") else {
            fatalError("Unable to dequeue reusable cell.")
        }
        cell.textLabel?.text = CitiesDataModel.cities[indexPath.row].city

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = CitiesDataModel.cities[indexPath.row]
        router.navigate(to: CitiesConfiguration.cityDetail(cityId: city.cityId))
    }

    @IBAction func goToSquareTapped() {
        router.navigate(to: ExampleConfiguration.destination(for: ExampleTarget.square)!)
    }
}

// To show master first in compact mode
// https://stackoverflow.com/questions/29506713/open-uisplitviewcontroller-to-master-view-rather-than-detail
extension CitiesTableViewController: UISplitViewControllerDelegate {

    func splitViewController(
            _ splitViewController: UISplitViewController,
            collapseSecondary secondaryViewController: UIViewController,
            onto primaryViewController: UIViewController) -> Bool {
        // Return true to prevent UIKit from applying its default behavior
        return true
    }

}
