//
// RouteComposer
// ImagesWithLibraryHandler.swift
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
import ImageDetailsController
import ImagesController
import os.log
import RouteComposer
import UIKit

@MainActor class ImagesWithLibraryHandler: CustomViewControllerDelegate, ImagesControllerDelegate, ImageDetailsControllerDelegate {

    static let shared = ImagesWithLibraryHandler()

    func didSelect(imageID: String, in controller: ImagesViewController) {
        try? UIViewController.router.navigate(to: ImagesConfigurationWithLibrary.imageDetails(for: imageID), animated: true)
    }

    func dismissCustomContainer(controller: CustomContainerController) {
        controller.dismiss(animated: true)
    }

    func dismiss(imageDetails: ImageDetailsViewController) {
        try? UIViewController.router.navigate(to: ImagesConfigurationWithLibrary.images(), animated: true, completion: nil)
    }

}
