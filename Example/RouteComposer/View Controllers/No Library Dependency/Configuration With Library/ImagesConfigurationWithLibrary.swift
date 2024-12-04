//
// RouteComposer
// ImagesConfigurationWithLibrary.swift
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
import RouteComposer
import UIKit

struct ImagesConfigurationWithLibrary {

    @MainActor private static let imagesContainerStep = StepAssembly(
        finder: ClassFinder<CustomContainerController, Any?>(),
        factory: CustomContainerFactory(delegate: ImagesWithLibraryHandler.shared))
        .using(UINavigationController.push())
        .from(NavigationControllerStep())
        .using(GeneralAction.presentModally())
        .from(GeneralStep.current())
        .assemble()

    @MainActor static func images() -> Destination<ImagesViewController, Any?> {
        let imagesStep = StepAssembly(
            finder: ClassFinder(),
            factory: ImagesFactory(delegate: ImagesWithLibraryHandler.shared))
            .using(CustomContainerFactory<Any?>.ReplaceRoot())
            .from(imagesContainerStep)
            .assemble()
        return Destination(to: imagesStep)
    }

    @MainActor static func imageDetails(for imageID: String) -> Destination<ImageDetailsViewController, String> {
        let imageDetailsStep = StepAssembly(
            finder: ClassFinder(),
            factory: ImageDetailsFactory(delegate: ImagesWithLibraryHandler.shared))
            .using(CustomContainerFactory<String>.ReplaceRoot())
            .from(imagesContainerStep.adaptingContext())
            .assemble()

        return Destination(to: imageDetailsStep, with: imageID)
    }

}
