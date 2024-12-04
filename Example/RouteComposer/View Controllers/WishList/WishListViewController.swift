//
// RouteComposer
// WishListViewController.swift
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

class WishListViewController: UITableViewController, ExampleAnalyticsSupport {

    var screenType = ExampleScreenTypes.favorites

    var segmentController = UISegmentedControl(items: ["Favorites", "Collections"])

    var context: WishListContext = .favorites {
        didSet {
            reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Wish list"
        segmentController.addTarget(self, action: #selector(segmentChanged), for: UIControl.Event.valueChanged)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        reloadData()
    }

    private func reloadData() {
        segmentController.selectedSegmentIndex = context.rawValue
        tableView.reloadData()
        screenType = context == .favorites ? .favorites : .collections
        tableView.accessibilityIdentifier = context == .favorites ? "favoritesViewController" : "collectionsViewController"
    }

    @objc func doneTapped() {
        dismiss(animated: true)
    }

    @IBAction func segmentChanged() {
        guard let selectedContext = WishListContext(rawValue: segmentController.selectedSegmentIndex) else {
            return
        }
        context = selectedContext
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        WishListDataModel.data[context]?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WishListCell") else {
            fatalError("Unable to dequeue reusable cell.")
        }
        cell.textLabel?.text = WishListDataModel.data[context]?[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else {
            return nil
        }
        return segmentController
    }

}
