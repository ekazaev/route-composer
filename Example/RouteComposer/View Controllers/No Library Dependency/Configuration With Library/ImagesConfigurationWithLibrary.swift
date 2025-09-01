//
// RouteComposer
// ImagesConfigurationWithLibrary.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2025.
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

enum ImagesConfigurationWithLibrary {

    @MainActor
    private static let imagesContainerStep = StepAssembler<CustomContainerController, Any?>()
        .finder(.classFinder)
        .factory(.customContainerFactory(delegate: ImagesWithLibraryHandler.shared)) // Or you can use `CustomContainerFactory(delegate: ImagesWithLibraryHandler.shared)`
        .using(.push)
        .from(.navigationController)
        .using(.present)
        .from(.current)
        .assemble()

    @MainActor
    static func images() -> Destination<ImagesViewController, Any?> {
        let imagesStep = StepAssembler()
            .finder(.classFinder)
            .factory(.imagesFactory(delegate: ImagesWithLibraryHandler.shared))
            .using(CustomContainerFactory<Any?>.ReplaceRoot())
            .from(imagesContainerStep)
            .assemble()
        return Destination(to: imagesStep)
    }

    @MainActor
    static func imageDetails(for imageID: String) -> Destination<ImageDetailsViewController, String> {
        let imageDetailsStep = StepAssembler()
            .finder(.classFinder)
            .factory(.imageDetailsFactory(delegate: ImagesWithLibraryHandler.shared))
            .using(CustomContainerFactory<String>.ReplaceRoot())
            .from(imagesContainerStep.adaptingContext())
            .assemble()

        return Destination(to: imageDetailsStep, with: imageID)
    }

}
