//
// Created by Eugene Kazaev on 23/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import DeepLinkLibrary
import UIKit

struct ImagesConfigurationWithLibrary {

    private static let imagesContainer = ScreenStepAssembly(
            finder: ViewControllerClassFinder(),
            factory: CustomContainerFactory(delegate: ConfigurationWithLibrary.shared, action: PushAction()))
            .from(NavigationContainerStep(action: PresentModallyAction()))
            .from(TopMostViewControllerStep())
            .assemble()

    static func images() -> ExampleDestination {
        return ExampleDestination(finalStep: ScreenStepAssembly(
                finder: ViewControllerClassFinder(),
                factory: ImagesFactory(delegate: ConfigurationWithLibrary.shared, action: CustomContainerChildAction()))
                .from(imagesContainer)
                .assemble(),
                context: nil)
    }

    static func imageDetails(for imageID: String) -> ExampleDestination {
        return ExampleDestination(finalStep: ScreenStepAssembly(
                finder: ViewControllerClassFinder(),
                factory: ImageDetailsFactory(delegate: ConfigurationWithLibrary.shared, action: CustomContainerChildAction()))
                .from(imagesContainer)
                .assemble(),
                context: imageID)
    }

}
