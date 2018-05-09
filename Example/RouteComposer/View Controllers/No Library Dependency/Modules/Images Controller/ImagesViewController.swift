//
// Created by Eugene Kazaev on 23/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class ImagesViewController: UITableViewController {

    weak var delegate: ImagesControllerDelegate?

    var imageFetcher: ImagesFetcher?

    private var imagesNames: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
    }

    private func reloadData() {
        self.view.accessibilityIdentifier = "imagesViewController"

        imageFetcher?.loadImages { imagesNames in
            self.imagesNames = imagesNames
            self.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesNames.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell") else {
            fatalError("Unable to dequeue reusable cell.")
        }
        cell.textLabel?.text = imagesNames[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didSelect(imageID: imagesNames[indexPath.row], in: self)
    }
}
