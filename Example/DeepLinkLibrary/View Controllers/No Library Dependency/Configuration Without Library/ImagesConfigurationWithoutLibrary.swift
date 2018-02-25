//
// Created by Eugene Kazaev on 25/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

// This is an example how you can implement same routing without dependency to DeepLinkLibrary.
// It may seem les complicated, but adding login/analytics/universal links support will make this implementation
// much more complicated.
class ImagesConfigurationWithoutLibrary: CustomViewControllerDelegate, ImagesControllerDelegate, ImageDetailsControllerDelegate {

    static let shared = ImagesConfigurationWithoutLibrary()

    func showCustomController() {
        // Handled by CustomContainerFactory
        guard let containerController = UIStoryboard(name: "Images", bundle: nil).instantiateViewController(withIdentifier: "CustomContainerController") as? CustomContainerController,
        // Handled by ImagesFactory
              let viewController = UIStoryboard(name: "Images", bundle: Bundle.main).instantiateViewController(withIdentifier: "ImagesViewController") as? ImagesViewController else {
            return
        }

        // Handled by ImagesFactory
        viewController.delegate = self
        viewController.imageFetcher = ImageFetcherImpl()

        // Handled by CustomContainerFactory
        containerController.delegate = self

        // Handled by CustomContainerChildAction
        containerController.rootViewController = viewController

        // Handled by NavigationContainerStep
        let navigationController = UINavigationController(rootViewController: containerController)

        // Handled by TopMostViewControllerStep
        let rootController = UIApplication.shared.keyWindow?.rootViewController

        // Handled by PresentModallyAction
        rootController?.present(navigationController, animated: true, completion: nil)
    }

    func dismissCustomContainer(controller: CustomContainerController) {
        controller.dismiss(animated: true)
    }

    func didSelect(imageID: String, in controller: ImagesViewController) {
        // Handled by ViewControllerClassFinder
        guard let containerController = controller.parent as? CustomContainerController,
        // Handled by ImageDetailsFactory
              let viewController = UIStoryboard(name: "Images", bundle: Bundle.main).instantiateViewController(withIdentifier: "ImageDetailsViewController") as? ImageDetailsViewController else {
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
        // Handled by ViewControllerClassFinder
        guard let containerController = imageDetails.parent as? CustomContainerController,
        // Handled by ImagesFactory
              let viewController = UIStoryboard(name: "Images", bundle: Bundle.main).instantiateViewController(withIdentifier: "ImagesViewController") as? ImagesViewController else {
            return
        }

        // Handled by ImagesFactory
        viewController.delegate = self
        viewController.imageFetcher = ImageFetcherImpl()

        // Handled by CustomContainerChildAction
        containerController.rootViewController = viewController
    }
}
