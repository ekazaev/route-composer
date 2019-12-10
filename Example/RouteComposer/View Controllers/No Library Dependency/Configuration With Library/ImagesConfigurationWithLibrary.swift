//
// Created by Eugene Kazaev on 23/02/2018.
//

import Foundation
import RouteComposer
import UIKit
import ImageDetailsController
import ImagesController
import ContainerViewController

struct ImagesConfigurationWithLibrary {

    private static let imagesContainerStep = StepAssembly(
            finder: ClassFinder<CustomContainerController, Any?>(),
            factory: CustomContainerFactory(delegate: ImagesWithLibraryHandler.shared))
            .using(UINavigationController.push())
            .from(NavigationControllerStep())
            .using(GeneralAction.presentModally())
            .from(GeneralStep.current())
            .assemble()

    static func images() -> Destination<ImagesViewController, Any?> {
        let imagesStep = StepAssembly(
                finder: ClassFinder(),
                factory: ImagesFactory(delegate: ImagesWithLibraryHandler.shared))
                .using(CustomContainerFactory<Any?>.ReplaceRoot())
                .from(imagesContainerStep)
                .assemble()
        return Destination(to: imagesStep)
    }

    static func imageDetails(for imageID: String) -> Destination<ImageDetailsViewController, String> {
        let imageDetailsStep = StepAssembly(
                finder: ClassFinder(),
                factory: ImageDetailsFactory(delegate: ImagesWithLibraryHandler.shared))
                .using(CustomContainerFactory<String>.ReplaceRoot())
                .from(imagesContainerStep.adaptingContext())
                .assemble()

        return Destination(to: imageDetailsStep, with: imageID)
    }

}
