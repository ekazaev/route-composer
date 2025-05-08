//
// RouteComposer
// CitiesTableViewController.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2025.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import RouteComposer
import UIKit

class CityTableContextTask: ContextTask {

    // `CitiesTableViewController` can perfectly work with the `Context` object of type `Int?`, but to demonstrate the possibility of context conversion,
    // we say that the actual context is `String?`. But it is done for demonstration and testing purposes only.
    func perform(on viewController: CitiesTableViewController, with cityIdAsString: String?) throws {
        guard let cityIdAsString else {
            viewController.cityId = nil
            return
        }

        guard let cityId = Int(cityIdAsString),
              CitiesDataModel.cities.map(\.cityId).contains(cityId) else {
            throw RoutingError.generic(.init("City id \(cityIdAsString) is invalid."))
        }
        viewController.cityId = cityId
    }

}

@MainActor
class CitiesTableViewController: UITableViewController, ExampleAnalyticsSupport {

    let screenType = ExampleScreenTypes.citiesList

    var cityId: Int? {
        didSet {
            guard let cityId else {
                return
            }
            let indexPath = IndexPath(row: cityId - 1, section: 0)

            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cities"
        splitViewController?.delegate = self
        splitViewController?.preferredDisplayMode = .allVisible
        splitViewController?.view.accessibilityIdentifier = "citiesSplitViewController"
        view.accessibilityIdentifier = "citiesViewController"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        CitiesDataModel.cities.count
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
//        try? router.navigate(to: CitiesConfiguration.cityDetail(cityId: city.cityId))
    }

    @IBAction func goToSquareTapped() {
        try? router.navigate(to: ConfigurationHolder.configuration.squareScreen, with: nil)
    }

    @IBAction func goToProductTapped() {
        // This is just for demo purposes and to test the last configuration in `ProductConfiguration`
        let router = router
        try? router.navigate(to: ConfigurationHolder.configuration.welcomeScreen, animated: true) { _ in
            UIApplication.shared.beginIgnoringInteractionEvents()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
                UIApplication.shared.endIgnoringInteractionEvents()
                try? router.navigate(to: ProductConfiguration.productScreen, with: ProductContext(productId: "123"), animated: true, completion: nil)
            }
        }
    }

}

// To show the master view controller first in the compact mode
// https://stackoverflow.com/questions/29506713/open-uisplitviewcontroller-to-master-view-rather-than-detail
extension CitiesTableViewController: UISplitViewControllerDelegate {

    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController) -> Bool {
        // Return true to prevent UIKit from applying its default behavior
        true
    }

}
