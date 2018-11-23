//
// Created by Eugene Kazaev on 25/02/2018.
// Copyright (c) 2018 HBC Digital. All rights reserved.
//

import Foundation
import RouteComposer
import UIKit
import ImageDetailsController

class ImageDetailsFactory: Factory {

    weak var delegate: ImageDetailsControllerDelegate?

    init(delegate: ImageDetailsControllerDelegate) {
        self.delegate = delegate
    }

    func build(with context: String) throws -> ImageDetailsViewController {
        guard let viewController = UIStoryboard(name: "Images", bundle: Bundle.main)
                .instantiateViewController(withIdentifier: "ImageDetailsViewController") as? ViewController else {
            throw RoutingError.compositionFailed(RoutingError.Context("Could not load ImagesViewController from the storyboard."))
        }
        viewController.delegate = delegate
        viewController.imageID = context
        viewController.imageFetcher = ImageDetailsFetcherImpl()
        return viewController
    }

}
