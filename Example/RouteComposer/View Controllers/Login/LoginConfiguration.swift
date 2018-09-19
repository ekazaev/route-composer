//
// Created by Eugene Kazaev on 19/01/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import RouteComposer

struct LoginConfiguration {

    static func login() -> ExampleDestination<LoginViewController, Any?> {
        let loginScreen = StepAssembly(finder: ClassFinder<LoginViewController, Any?>(),
                factory: NilFactory()) //Login view controller will be created when UINavigationController will be loaded from storyboard.
                .within(SingleStep(
                        finder: NilFinder(),
                        factory: StoryboardFactory<UIViewController, Any?>(storyboardName: "Login")))
                .using(GeneralAction.presentModally(presentationStyle: .formSheet))
                .from(GeneralStep.current())
                .assemble()

        return ExampleDestination(step: loginScreen, context: nil)
    }

}
