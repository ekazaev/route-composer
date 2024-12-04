//
// RouteComposer
// LoginConfiguration.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import RouteComposer

struct LoginConfiguration {

    @MainActor static func login() -> Destination<LoginViewController, Void> {
        let loginScreen = StepAssembly(finder: ClassFinder<LoginViewController, Void>(),
                                       factory: NilFactory()) // Login view controller will be created when UINavigationController will be loaded from storyboard.
            .from(SingleStep(
                finder: NilFinder(),
                factory: StoryboardFactory<UINavigationController, Void>(name: "Login")))
            .using( // `custom` and `overCurrentContext` are set for the test purposes only
                GeneralAction.presentModally(startingFrom: .custom(RouteComposerDefaults.shared.windowProvider.window?.topmostViewController),
                                             presentationStyle: .overCurrentContext))
            .from(GeneralStep.current())
            .assemble()

        return Destination(to: loginScreen)
    }

}
