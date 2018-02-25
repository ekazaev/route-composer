//
// Created by Eugene Kazaev on 25/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import DeepLinkLibrary
import UIKit

class ImageDetailsFactory: MandatoryContextFactory {

    typealias ViewController = ImageDetailsViewController

    typealias Context = String

    let action: Action

    let delegate: ImageDetailsControllerDelegate

    init(delegate: ImageDetailsControllerDelegate, action: Action) {
        self.action = action
        self.delegate = delegate
    }

    func build(with context: Context) -> FactoryBuildResult {
        guard let viewController = UIStoryboard(name: "Images", bundle: Bundle.main)
                .instantiateViewController(withIdentifier: "ImageDetailsViewController") as? ViewController else {
            return .failure("Could not load ImagesViewController from storyboard.")
        }
        viewController.delegate = delegate
        viewController.imageID = context
        viewController.imageFetcher = ImageDetailsFetcherImpl()
        return .success(viewController)
    }

}