//
// RouteComposer
// ImagesWithoutLibraryHandler.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2026.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import ContainerViewController
import Foundation
import ImageDetailsController
import ImagesController
import UIKit

// This is an example how you can implement the same navigation configuration without the dependency to RouteComposer.
// It may seem les complicated, but adding login/analytics/universal links support/navigation to the other parts of the app
// will make this implementation much more complicated.
class ImagesWithoutLibraryHandler: CustomViewControllerDelegate, ImagesControllerDelegate, ImageDetailsControllerDelegate {

    func dismissCustomContainer(controller: CustomContainerController) {
        controller.dismiss(animated: true)
    }

    func didSelect(imageID: String, in controller: ImagesViewController) {
        // Handled by ClassFinder
        let storyboard = UIStoryboard(name: "Images", bundle: Bundle.main)
        guard let containerController = controller.parent as? CustomContainerController,
              // Handled by ImageDetailsFactory
              let viewController = storyboard.instantiateViewController(withIdentifier: "ImageDetailsViewController") as? ImageDetailsViewController else {
            return
        }

        // Handled by ImageDetailsFactory
        viewController.imageFetcher = ImageDetailsFetcherImpl()
        viewController.delegate = self
        viewController.imageID = imageID

        // Handled by CustomContainerChildAction
        containerController.rootViewController = viewController
    }

    func dismiss(imageDetails: ImageDetailsViewController) {
        // Handled by ClassFinder
        let storyboard = UIStoryboard(name: "Images", bundle: Bundle.main)
        guard let containerController = imageDetails.parent as? CustomContainerController,
              // Handled by ImagesFactory
              let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesViewController") as? ImagesViewController else {
            return
        }

        // Handled by ImagesFactory
        viewController.delegate = self
        viewController.imageFetcher = ImageFetcherImpl()

        // Handled by CustomContainerChildAction
        containerController.rootViewController = viewController
    }

}
