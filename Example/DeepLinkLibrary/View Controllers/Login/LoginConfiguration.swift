//
// Created by Eugene Kazaev on 19/01/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import DeepLinkLibrary

struct LoginConfiguration {

    static func login() -> ExampleDestination {
        let loginScreen = ScreenStepAssembly(finder: LoginViewControllerFinder(),
                factory: NilFactory()) //Its actually funny here. You can not load here LoginViewController from a storyboard - because it UINavigationController will be created first. So all this fancy abstraction involves more coding.
                .from(RouterStep(factory: ViewControllerFromStoryboard<UINavigationController, Any>(storyboardName: "Login", action: PresentModallyAction(presentationStyle: .formSheet))))
                .from(TopMostViewControllerStep())
                .assemble()

        return ExampleDestination(finalStep: loginScreen, arguments: nil)
    }

}
