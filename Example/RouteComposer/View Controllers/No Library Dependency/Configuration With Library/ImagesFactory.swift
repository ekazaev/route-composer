//
// Created by Eugene Kazaev on 25/02/2018.
// Copyright (c) 2018 HBC Digital. All rights reserved.
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

    func build(with context: Any?) throws -> ImagesViewController {
        guard let viewController = UIStoryboard(name: "Images", bundle: Bundle.main)
                .instantiateViewController(withIdentifier: "ImagesViewController") as? ViewController else {
            throw RoutingError.compositionFailed(.init("Could not load ImagesViewController from the storyboard."))
        }
        viewController.delegate = delegate
        viewController.imageFetcher = ImageFetcherImpl()
        return viewController
    }

}
