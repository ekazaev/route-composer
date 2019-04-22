//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright © 2018 HBC Digital. All rights reserved.
//

import Foundation
import RouteComposer

// Instance like this can represent both final screen configuration and the value to provide.
// NB: Used for the demo purposes only. Supported by a Router extension in the example app.
class ExampleDestination<VC: UIViewController, C> {

    let step: DestinationStep<VC, C>

    let context: C

    init(step: DestinationStep<VC, C>, context: C) {
        self.step = step
        self.context = context
    }

    func unwrapped() -> ExampleDestination<UIViewController, Any?> {
        return ExampleDestination<UIViewController, Any?>(step: step.unsafelyRewrapped(), context: context)
    }

}
