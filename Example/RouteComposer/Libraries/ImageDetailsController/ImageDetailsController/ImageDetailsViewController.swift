//
// RouteComposer
// ImageDetailsViewController.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import UIKit

public final class ImageDetailsViewController: UIViewController {

    @IBOutlet private var imageView: UIImageView!

    public weak var delegate: ImageDetailsControllerDelegate?

    public var imageFetcher: ImageDetailsFetcher?

    public var imageID: String? {
        didSet {
            reloadData()
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
    }

    private func reloadData() {
        guard isViewLoaded, let imageID else {
            return
        }
        view.accessibilityIdentifier = "image\(imageID)ViewController"

        imageFetcher?.details(for: imageID) { image in
            self.imageView.image = image
        }
    }

    @IBAction func doneTapped() {
        delegate?.dismiss(imageDetails: self)
    }

}
