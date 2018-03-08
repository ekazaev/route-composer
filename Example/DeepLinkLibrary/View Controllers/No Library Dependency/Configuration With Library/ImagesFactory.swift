//
// Created by Eugene Kazaev on 25/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import DeepLinkLibrary
import UIKit

class ImagesFactory: Factory {

    let action: Action

    let delegate: ImagesControllerDelegate

    init(delegate: ImagesControllerDelegate, action: Action) {
        self.action = action
        self.delegate = delegate
    }

    func build(with context: Any?) throws -> ImagesViewController {
        guard let viewController = UIStoryboard(name: "Images", bundle: Bundle.main)
                .instantiateViewController(withIdentifier: "ImagesViewController") as? ViewController else {
            throw RoutingError.message("Could not load ImagesViewController from storyboard.")
        }
        viewController.delegate = delegate
        viewController.imageFetcher = ImageFetcherImpl()
        return viewController
    }

}