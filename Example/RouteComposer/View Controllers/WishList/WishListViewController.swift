//
// Created by Eugene Kazaev on 07/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer

class WishListViewController: UITableViewController, ExampleAnalyticsSupport {

    var analyticParameters = ExampleAnalyticsParameters(source: .favorites)

    var segmentController = UISegmentedControl(items: ["Favorites", "Collections"])

    var content: WishListContent = .favorites {
        didSet {
            reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        segmentController.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        reloadData()
    }

    private func reloadData() {
        segmentController.selectedSegmentIndex = content.rawValue
        tableView.reloadData()
        analyticParameters = ExampleAnalyticsParameters(source: content == .favorites ? .favorites : .collections)
        tableView.accessibilityIdentifier = content == .favorites ? "favoritesViewController" : "collectionsViewController"
    }

    @objc func doneTapped() {
        self.dismiss(animated: true)
    }

    @IBAction func segmentChanged() {
        guard let selectedContent = WishListContent(rawValue: segmentController.selectedSegmentIndex) else {
            return
        }
        content = selectedContent
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WishListDataModel.data[content]?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WishListCell") else {
            fatalError("Unable to dequeue reusable cell.")
        }
        cell.textLabel?.text = WishListDataModel.data[content]?[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else {
            return nil
        }
        return segmentController
    }

}
