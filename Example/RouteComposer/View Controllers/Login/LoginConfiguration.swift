//
// Created by Eugene Kazaev on 19/01/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import RouteComposer

struct LoginConfiguration {

    static func login() -> ExampleDestination<LoginViewController, Any?> {
        let loginScreen = DestinationAssembly<Any?>(from: GeneralStep.current())
                .using(GeneralAction.presentModally())
                .present(SingleStep(
                        finder: NilFinder(),
                        factory: StoryboardFactory<UINavigationController, Any?>(storyboardName: "Login")))
                .inside()
                .present(SingleStep(finder: ClassFinder<LoginViewController, Any?>(),
                        factory: NilFactory()))
                .assemble()

        return ExampleDestination(step: loginScreen, context: nil)
    }

}
