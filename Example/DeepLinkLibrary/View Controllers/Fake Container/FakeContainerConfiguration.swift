//
// Created by Eugene Kazaev on 08/02/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

struct FakeContainerConfiguration {

    static let fakeContainerScreen = ScreenStepAssembly(
            finder: ViewControllerClassFinder(classType: FakeContainerViewController.self),
            factory: FakeContainerFactory(action: PushAction()))
            .add(LoginInterceptor())
            .add(ExampleAnalyticsInterceptor())
            .add(ExampleAnalyticsPostAction())
            .from(NavigationContainerStep(action: PresentModallyAction(presentationStyle: .formSheet)))
            .from(TopMostViewControllerStep())
            .assemble()

    static func favorites() -> ExampleDestination {
        return ExampleDestination(finalStep: fakeContainerScreen, arguments: FakeContainerArguments(content: FakeContainerContent.favorites))
    }

    static func collections() -> ExampleDestination {
        return ExampleDestination(finalStep: fakeContainerScreen, arguments: FakeContainerArguments(content: FakeContainerContent.collections))
    }

}