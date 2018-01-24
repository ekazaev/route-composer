//
// Created by Eugene Kazaev on 19/01/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import DeepLinkLibrary

struct LoginConfiguration {

    static func login() -> ExampleDestination {
        let loginAssembly = ViewControllerAssembly(
                finder: LoginViewControllerFinder(),
                factory: ViewControllerFromStoryboard(storyboardName: "Login", action: PresentModallyAction(presentationStyle: .formSheet)),
                step: TopMostViewControllerStep())

        return ExampleDestination(finalStep: loginAssembly, arguments: nil)
    }

}
