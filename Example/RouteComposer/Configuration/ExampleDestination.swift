//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import RouteComposer

// Instance like this can represent both final screen and value to provide.
class ExampleDestination<VC: UIViewController, C> {

    let step: DestinationStep<VC, C>

    let context: C

    init(step: DestinationStep<VC, C>, context: C) {
        self.step = step
        self.context = context
    }

    func unsafelyUnwrapped() -> ExampleDestination<UIViewController, Any?> {
        return ExampleDestination<UIViewController, Any?>(step: step.unsafelyUnwrapped(), context: context)
    }

}
