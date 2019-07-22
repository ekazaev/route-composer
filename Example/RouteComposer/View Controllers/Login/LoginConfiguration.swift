//
// Created by Eugene Kazaev on 19/01/2018.
// Copyright (c) 2018 HBC Digital. All rights reserved.
//

import Foundation
import RouteComposer

struct LoginConfiguration {

    static func login() -> Destination<LoginViewController, Void> {
        let loginScreen = StepAssembly(finder: ClassFinder<LoginViewController, Void>(),
                factory: NilFactory()) //Login view controller will be created when UINavigationController will be loaded from storyboard.
                .from(SingleStep(
                        finder: NilFinder(),
                        factory: StoryboardFactory<UINavigationController, Void>(storyboardName: "Login")))
                .using(GeneralAction.presentModally(presentationStyle: .formSheet))
                .from(GeneralStep.current())
                .assemble()

        return Destination(to: loginScreen)
    }

}
