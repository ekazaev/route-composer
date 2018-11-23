//
// Created by Eugene Kazaev on 23/02/2018.
// Copyright (c) 2018 HBC Digital. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer
import os.log
import ContainerViewController
import ImageDetailsController
import ImagesController

class ImagesWithLibraryHandler: CustomViewControllerDelegate, ImagesControllerDelegate, ImageDetailsControllerDelegate {

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
