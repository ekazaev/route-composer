//
// Created by Eugene Kazaev on 23/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import RouteComposer
import UIKit
import ImageDetailsController
import ImagesController
import ContainerViewController

struct ImagesConfigurationWithLibrary {

    private static let imagesContainerStep = DestinationAssembly(from: GeneralStep.current())
            .using(GeneralAction.presentModally())
            .present(NavigationControllerStep())
            .using(UINavigationController.pushToNavigation())
            .present(SingleContainerStep(finder: ClassFinder<CustomContainerController, Any?>(),
                    factory: CustomContainerFactory(delegate: ImagesWithLibraryHandler.shared)))
            .assemble()

    static func images() -> ExampleDestination<ImagesViewController, Any?> {
        let imagesStep = ContainerDestinationAssembly(from: imagesContainerStep)
                .using(CustomContainerFactory<Any?>.ReplaceRoot())
                .present(SingleStep(
                        finder: ClassFinder(),
                        factory: ImagesFactory(delegate: ImagesWithLibraryHandler.shared)))
                .assemble()
        return ExampleDestination(step: imagesStep, context: nil)
    }

    static func imageDetails(for imageID: String) -> ExampleDestination<ImageDetailsViewController, String> {
        let imageDetailsStep = ContainerDestinationAssembly(from: imagesContainerStep.adaptingContext())
                .using(CustomContainerFactory<String>.ReplaceRoot())
                .present(SingleStep(finder: ClassFinder(),
                        factory: ImageDetailsFactory(delegate: ImagesWithLibraryHandler.shared)))
                .assemble()
        return ExampleDestination(step: imageDetailsStep, context: imageID)
    }

}
