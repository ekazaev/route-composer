//
// Created by Eugene Kazaev on 19/01/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import DeepLinkLibrary

struct LoginConfiguration {

    static func login() -> ExampleDestination {
        let loginScreen = ScreenStepAssembly(finder: ViewControllerClassFinder<LoginViewController, Any?>(),
                factory: NilFactory()) //Login view controller will be created when UINavigationController will be loaded from storyboard.
                .from(BasicStep(finder: NilFinder<UINavigationController, Any?>(), factory: ViewControllerFromStoryboard<UINavigationController, Any?>(storyboardName: "Login", action: PresentModallyAction(presentationStyle: .formSheet))))
                .from(CurrentViewControllerStep())
                .assemble()

        return ExampleDestination(finalStep: loginScreen, context: nil)
    }

}
