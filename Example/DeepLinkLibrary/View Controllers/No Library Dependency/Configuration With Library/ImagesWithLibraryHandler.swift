//
// Created by Eugene Kazaev on 23/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary
import os.log

class ImagesWithLibraryHandler: CustomViewControllerDelegate, ImagesControllerDelegate, ImageDetailsControllerDelegate {

    static let shared = ImagesWithLibraryHandler()

    var router: DefaultRouter {
        get {
            let appRouterLogger: DefaultLogger
            if #available(iOS 10, *) {
                appRouterLogger = DefaultLogger(.verbose, osLog: OSLog(subsystem: "org.cocoapods.demo.DeepLinkLibrary-Example", category: "Router"))
            } else {
                appRouterLogger = DefaultLogger(.verbose)
            }
            let router = DefaultRouter(logger: appRouterLogger)
            return router
        }
    }

    func didSelect(imageID: String, in controller: ImagesViewController) {
        router.deepLinkTo(destination: ImagesConfigurationWithLibrary.imageDetails(for: imageID), animated: true, completion: nil)
    }

    func dismissCustomContainer(controller: CustomContainerController) {
        controller.dismiss(animated: true)
    }

    func dismiss(imageDetails: ImageDetailsViewController) {
        router.deepLinkTo(destination: ImagesConfigurationWithLibrary.images(), animated: true, completion: nil)
    }

}
