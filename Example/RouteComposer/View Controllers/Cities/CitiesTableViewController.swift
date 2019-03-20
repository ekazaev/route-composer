//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright © 2018 HBC Digital. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer

class CityTableContextTask: ContextTask {

    func apply(on viewController: CitiesTableViewController, with context: Int?) throws {
        viewController.cityId = context
    }

}

class CitiesTableViewController: UITableViewController, ExampleAnalyticsSupport {

    let screenType = ExampleScreenTypes.citiesList

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
        try? router.navigate(to: CitiesConfiguration.cityDetail(cityId: city.cityId))
    }

    @IBAction func goToSquareTapped() {
        try? router.navigate(to: ConfigurationHolder.configuration.squareScreen, with: nil)
    }

    @IBAction func goToProductTapped() {
        // This is just for demo purposes and to test the last configuration in `ProductConfiguration`
        let router = self.router
        try? router.navigate(to: ConfigurationHolder.configuration.welcomeScreen, animated: true) { _ in
            UIApplication.shared.beginIgnoringInteractionEvents()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                UIApplication.shared.endIgnoringInteractionEvents()
                try? router.navigate(to: ProductConfiguration.productScreen, with: ProductContext(productId: "123"), animated: true, completion: nil)
            })
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
        return true
    }

}
