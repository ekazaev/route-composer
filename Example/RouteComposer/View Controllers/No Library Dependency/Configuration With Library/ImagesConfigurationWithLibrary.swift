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

    private static let imagesContainerStep = ContainerStepAssembly(
            finder: ClassFinder<CustomContainerController, Any?>(),
            factory: CustomContainerFactory(delegate: ImagesWithLibraryHandler.shared))
            .using(NavigationControllerFactory.PushToNavigation())
            .from(NavigationControllerStep())
            .using(GeneralAction.PresentModally())
            .from(CurrentViewControllerStep())
            .assemble()

    static func images() -> ExampleDestination {
        let imagesStep = StepAssembly(
                finder: ClassFinder(),
                factory: ImagesFactory(delegate: ImagesWithLibraryHandler.shared))
                .using(CustomContainerFactory.ReplaceRoot())
                .from(imagesContainerStep)
                .assemble()
        return ExampleDestination(finalStep: imagesStep.lastStep, context: nil)
    }

    static func imageDetails(for imageID: String) -> ExampleDestination {
        let imageDetailsStep = StepAssembly(
                finder: ClassFinder(),
                factory: ImageDetailsFactory(delegate: ImagesWithLibraryHandler.shared))
                .using(CustomContainerFactory.ReplaceRoot())
                .from(imagesContainerStep)
                .assemble()
        return ExampleDestination(finalStep: imageDetailsStep.lastStep, context: imageID)
    }

}
