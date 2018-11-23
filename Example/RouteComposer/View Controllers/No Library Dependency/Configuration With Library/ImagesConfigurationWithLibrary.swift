//
// Created by Eugene Kazaev on 23/02/2018.
// Copyright (c) 2018 HBC Digital. All rights reserved.
//

import Foundation
import RouteComposer
import UIKit
import ImageDetailsController
import ImagesController
import ContainerViewController

struct ImagesConfigurationWithLibrary {

    private static let imagesContainerStep = ContainerStepAssembly(
            finder: ClassFinder<CustomContainerController, Any?>(),
            factory: CustomContainerFactory(delegate: ImagesWithLibraryHandler.shared))
            .using(UINavigationController.push())
            .from(NavigationControllerStep())
            .using(GeneralAction.presentModally())
            .from(GeneralStep.current())
            .assemble()

    static func images() -> ExampleDestination<ImagesViewController, Any?> {
        let imagesStep = StepAssembly(
                finder: ClassFinder(),
                factory: ImagesFactory(delegate: ImagesWithLibraryHandler.shared))
                .using(CustomContainerFactory<Any?>.ReplaceRoot())
                .from(imagesContainerStep)
                .assemble()
        return ExampleDestination(step: imagesStep, context: nil)
    }

    static func imageDetails(for imageID: String) -> ExampleDestination<ImageDetailsViewController, String> {
        let imageDetailsStep = StepAssembly(
                finder: ClassFinder(),
                factory: ImageDetailsFactory(delegate: ImagesWithLibraryHandler.shared))
                .using(CustomContainerFactory<String>.ReplaceRoot())
                .from(imagesContainerStep.adaptingContext())
                .assemble()

        return ExampleDestination(step: imageDetailsStep, context: imageID)
    }

}
