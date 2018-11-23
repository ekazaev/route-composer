//
// Created by Eugene Kazaev on 07/02/2018.
// Copyright (c) 2018 HBC Digital. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer

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
        segmentController.addTarget(self, action: #selector(segmentChanged), for: UIControl.Event.valueChanged)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        reloadData()
    }

    private func reloadData() {
        segmentController.selectedSegmentIndex = context.rawValue
        tableView.reloadData()
        screenType = context == .favorites ? .favorites : .collections
        tableView.accessibilityIdentifier = context == .favorites ? "favoritesViewController" : "collectionsViewController"
    }

    @objc func doneTapped() {
        self.dismiss(animated: true)
    }

    @IBAction func segmentChanged() {
        guard let selectedContext = WishListContext(rawValue: segmentController.selectedSegmentIndex) else {
            return
        }
        context = selectedContext
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WishListDataModel.data[context]?.count ?? 0
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
