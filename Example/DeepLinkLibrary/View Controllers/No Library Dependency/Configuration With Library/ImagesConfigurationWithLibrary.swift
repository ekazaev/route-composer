//
// Created by Eugene Kazaev on 23/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import DeepLinkLibrary
import UIKit

struct ImagesConfigurationWithLibrary {

    private static let imagesContainerStep = ScreenStepAssembly(
            finder: ViewControllerClassFinder(),
            factory: CustomContainerFactory(delegate: ImagesWithLibraryHandler.shared, action: PushToNavigationAction()))
            .from(NavigationControllerStep(action: PresentModallyAction()))
            .from(CurrentViewControllerStep())
            .assemble()

    static func images() -> ExampleDestination {
        let imagesStep = ScreenStepAssembly(
                finder: ViewControllerClassFinder(),
                factory: ImagesFactory(delegate: ImagesWithLibraryHandler.shared, action: CustomContainerChildAction()))
                .from(imagesContainerStep)
                .assemble()
        return ExampleDestination(finalStep: imagesStep, context: nil)
    }

    static func imageDetails(for imageID: String) -> ExampleDestination {
        let imageDetailsStep = ScreenStepAssembly(
                finder: ViewControllerClassFinder(),
                factory: ImageDetailsFactory(delegate: ImagesWithLibraryHandler.shared, action: CustomContainerChildAction()))
                .from(imagesContainerStep)
                .assemble()
        return ExampleDestination(finalStep: imageDetailsStep, context: imageID)
    }

}
