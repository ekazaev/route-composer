//
// RouteComposer
// ImagesFactory.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import ImagesController
import RouteComposer
import UIKit

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
