//
// Created by Eugene Kazaev on 19/01/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import DeepLinkLibrary

struct LoginConfiguration {

    static func login() -> ExampleDestination {
        let loginScreen = Screen(
                finder: LoginViewControllerFinder(),
                factory: ViewControllerFromStoryboard(storyboardName: "Login", action: PresentModallyAction()),
                step: TopMostViewControllerStep())

        return ExampleDestination(screen: loginScreen, arguments: nil)
    }

}
