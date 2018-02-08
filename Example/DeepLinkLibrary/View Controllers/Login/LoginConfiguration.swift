//
// Created by Eugene Kazaev on 19/01/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import DeepLinkLibrary

struct LoginConfiguration {

    static func login() -> ExampleDestination {
        let loginScreen = ScreenStepAssembly(finder: LoginViewControllerFinder(),
                factory: NilFactory()) //Its actually funny here. You have to be persize in abstraction. You can not load here LoginViewController from a storyboard - because it UINavigation coler first. So all this fancy abstraction involves a lot of cpding
                .from(ScreenStepAssembly(finder: NilFinder(), factory: ViewControllerFromStoryboard<UINavigationController, Any>(storyboardName: "Login", action: PresentModallyAction(presentationStyle: .formSheet))).assemble(from: TopMostViewControllerStep()))
                .assemble()

        return ExampleDestination(finalStep: loginScreen, arguments: nil)
    }

}
