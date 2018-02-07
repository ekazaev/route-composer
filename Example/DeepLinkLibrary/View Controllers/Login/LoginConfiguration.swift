//
// Created by Eugene Kazaev on 19/01/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import DeepLinkLibrary

struct LoginConfiguration {

    static func login() -> ExampleDestination {
        let loginScreen = ViewControllerAssembly(finder: LoginViewControllerFinder(),
                factory: ViewControllerFromStoryboard(storyboardName: "Login", action: PresentModallyAction(presentationStyle: .formSheet)))
                .from(TopMostViewControllerStep())
                .assemble()

        return ExampleDestination(finalStep: loginScreen, arguments: nil)
    }

}
