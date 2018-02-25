//
// Created by Eugene Kazaev on 25/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class ImageDetailsViewController: UIViewController {

    @IBOutlet private var imageView: UIImageView!

    weak var delegate: ImageDetailsControllerDelegate? = nil

    var imageFetcher: ImageDetailsFetcher? = nil

    var imageID: String? {
        didSet {
            reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
    }

    private func reloadData() {
        guard isViewLoaded, let imageID = imageID else {
            return
        }
        imageFetcher?.details(for: imageID) { image in
            self.imageView.image = image
        }
    }

    @IBAction func doneTapped() {
        delegate?.dismiss(imageDetails: self)
    }

}
