//
// Created by Eugene Kazaev on 26/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

// This is an example how you can implement same routing without dependency to RouteComposer.
// It may seem les complicated, but adding login/analytics/universal links support/routing to the other parts of the app
// will make this implementation much more complicated.
class ImagesWithoutLibraryConfiguration {

    static let shared = ImagesWithoutLibraryConfiguration()

    private static let handler = ImagesWithoutLibraryHandler()

    func showCustomController() {
        // Handled by CustomContainerFactory
        guard let containerController = UIStoryboard(name: "Images", bundle: nil).instantiateViewController(withIdentifier: "CustomContainerController") as? CustomContainerController,
        // Handled by ImagesFactory
              let viewController = UIStoryboard(name: "Images", bundle: Bundle.main).instantiateViewController(withIdentifier: "ImagesViewController") as? ImagesViewController else {
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
        let rootController = UIApplication.shared.keyWindow?.rootViewController

        // Handled by PresentModally action
        rootController?.present(navigationController, animated: true, completion: nil)
    }

}
