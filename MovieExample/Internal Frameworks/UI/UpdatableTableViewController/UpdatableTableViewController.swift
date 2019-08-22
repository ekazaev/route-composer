//
// Created by Eugene Kazaev on 2019-08-21.
// Copyright (c) 2019 Eugene Kazaev. All rights reserved.
//

import Foundation
import UIKit

public class UpdatableTableViewController<Controller: ListController, TableViewCell: UpdatableTableViewCell>: UITableViewController where Controller.Item == TableViewCell.Data {

    public var controller: Controller? {
        didSet {
            controller?.delegate = self
            title = controller?.title
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        controller?.loadNextPage()
        TableViewCell.register(in: tableView)
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller?.items.count ?? 0
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let controller = controller,
              let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reusableIdentifier, for: indexPath) as? TableViewCell else {
            fatalError()
        }
        let item = controller.items[indexPath.item]

        cell.setup(with: item)
        return cell
    }

    private var lastAmount = 0

    public override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard lastAmount != controller?.items.count else {
            return
        }
        let visibleHeight = tableView.contentSize.height - tableView.contentInset.top - tableView.contentInset.bottom - tableView.bounds.height
        if tableView.contentOffset.y + (tableView.bounds.height / 2) > visibleHeight {
            lastAmount = controller?.items.count ?? 0
            controller?.loadNextPage()
        }
    }

}

extension UpdatableTableViewController: ListControllerDelegate {

    public func reloadData() {
        tableView.reloadData()
    }

}

public protocol ListControllerDelegate: AnyObject {

    func reloadData()

}

public protocol ListController {

    associatedtype Item

    var delegate: ListControllerDelegate? { get set }

    var items: [Item] { get }

    var title: String { get }

    func loadNextPage()

}
