//
// Created by Eugene Kazaev on 23/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import RouteComposer
import UIKit
import ImageDetailsController
import ImagesController

struct ImagesConfigurationWithLibrary {

    private static let imagesContainerStep = ContainerStepAssembly(
            finder: ClassFinder(),
            factory: CustomContainerFactory(delegate: ImagesWithLibraryHandler.shared, action: NavigationControllerFactory.PushToNavigation()))
            .from(NavigationControllerStep(action: GeneralAction.PresentModally()))
            .from(CurrentViewControllerStep())
            .assemble()

    static func images() -> ExampleDestination {
        let imagesStep = StepAssembly(
                finder: ClassFinder(),
                factory: ImagesFactory(delegate: ImagesWithLibraryHandler.shared, action: CustomContainerFactory.ReplaceRoot()))
                .from(imagesContainerStep)
                .assemble()
        return ExampleDestination(finalStep: imagesStep, context: nil)
    }

    static func imageDetails(for imageID: String) -> ExampleDestination {
        let imageDetailsStep = StepAssembly(
                finder: ClassFinder(),
                factory: ImageDetailsFactory(delegate: ImagesWithLibraryHandler.shared, action: CustomContainerFactory.ReplaceRoot()))
                .from(imagesContainerStep)
                .assemble()
        return ExampleDestination(finalStep: imageDetailsStep, context: imageID)
    }

}
