//
// Created by Eugene Kazaev on 25/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import RouteComposer
import UIKit
import ImagesController

class ImagesFactory: Factory {

    typealias ViewController = ImagesViewController

    typealias Context = Any?

    weak var delegate: ImagesControllerDelegate?

    init(delegate: ImagesControllerDelegate) {
        self.delegate = delegate
    }

    func build(with context: Context) throws -> ViewController {
        guard let viewController = UIStoryboard(name: "Images", bundle: Bundle.main)
                .instantiateViewController(withIdentifier: "ImagesViewController") as? ViewController else {
            throw RoutingError.compositionFailed(RoutingError.Context(debugDescription: "Could not load ImagesViewController from the storyboard."))
        }
        viewController.delegate = delegate
        viewController.imageFetcher = ImageFetcherImpl()
        return viewController
    }

}
