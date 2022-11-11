//
// RouteComposer
// ImagesViewController.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import UIKit

public final class ImagesViewController: UITableViewController {

    public weak var delegate: ImagesControllerDelegate?

    public var imageFetcher: ImagesFetcher?

    private var imagesNames: [String] = []

    public override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
    }

    private func reloadData() {
        view.accessibilityIdentifier = "imagesViewController"

        imageFetcher?.loadImages { imagesNames in
            self.imagesNames = imagesNames
            self.tableView.reloadData()
        }
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        imagesNames.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell") else {
            fatalError("Unable to dequeue a reusable cell.")
        }
        cell.textLabel?.text = imagesNames[indexPath.row]
        return cell
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelect(imageID: imagesNames[indexPath.row], in: self)
    }

}
