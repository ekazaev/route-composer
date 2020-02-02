//
// Created by Eugene Kazaev on 19/01/2018.
//

import Foundation
import RouteComposer

struct LoginConfiguration {

    static func login() -> Destination<LoginViewController, Void> {
        let loginScreen = StepAssembly(finder: ClassFinder<LoginViewController, Void>(),
                                       factory: NilFactory()) // Login view controller will be created when UINavigationController will be loaded from storyboard.
            .from(SingleStep(
                finder: NilFinder(),
                factory: StoryboardFactory<UINavigationController, Void>(name: "Login")
            ))
            .using( // `custom` and `overCurrentContext` are set for the test purposes only
                GeneralAction.presentModally(startingFrom: .custom(KeyWindowProvider().window?.topmostViewController),
                                             presentationStyle: .overCurrentContext)
            )
            .from(GeneralStep.current())
            .assemble()

        return Destination(to: loginScreen)
    }

}
