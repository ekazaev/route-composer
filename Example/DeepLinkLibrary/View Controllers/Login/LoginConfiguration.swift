//
// Created by Eugene Kazaev on 19/01/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import DeepLinkLibrary

struct LoginConfiguration {

    static func login() -> ExampleDestination {
        let loginScreen = ScreenStepAssembly(finder: LoginViewControllerFinder(),
                factory: NilFactory()) //Login view controller will be created when UINavigationController will be loaded from storyboard.
                .from(RouterStep(factory: ViewControllerFromStoryboard<UINavigationController, Any>(storyboardName: "Login", action: PresentModallyAction(presentationStyle: .formSheet))))
                .from(TopMostViewControllerStep())
                .assemble()

        return ExampleDestination(finalStep: loginScreen, context: nil)
    }

}
