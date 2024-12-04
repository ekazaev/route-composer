//
// RouteComposer
// ImagesWithoutLibraryConfiguration.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import ContainerViewController
import Foundation
import ImagesController
import UIKit

// This is an example how you can implement same navigation configuration without dependency to RouteComposer.
// It may seem les complicated, but adding login/analytics/universal links support to the other parts of the app
// will make this implementation much more complicated.
@MainActor class ImagesWithoutLibraryConfiguration {

    static let shared = ImagesWithoutLibraryConfiguration()

    private static let handler = ImagesWithoutLibraryHandler()

    func showCustomController() {
        // Handled by CustomContainerFactory
        let storyboard = UIStoryboard(name: "Images", bundle: Bundle.main)
        guard let containerController = storyboard.instantiateViewController(withIdentifier: "CustomContainerController") as? CustomContainerController,
              // Handled by ImagesFactory
              let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesViewController") as? ImagesViewController else {
            return
        }

        // Handled by ImagesFactory
        viewController.delegate = ImagesWithoutLibraryConfiguration.handler
        viewController.imageFetcher = ImageFetcherImpl()

        // Handled by CustomContainerFactory
        containerController.delegate = ImagesWithoutLibraryConfiguration.handler

        // Handled by CustomContainerChildAction
        containerController.rootViewController = viewController

        // Handled by NavigationContainerStep
        let navigationController = UINavigationController(rootViewController: containerController)

        // Handled by TopMostViewControllerStep
        let rootController = UIApplication.shared.windows.first?.rootViewController

        // Handled by PresentModally action
        rootController?.present(navigationController, animated: true, completion: nil)
    }

}
