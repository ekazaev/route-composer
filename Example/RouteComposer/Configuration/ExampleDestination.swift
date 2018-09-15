//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import RouteComposer

// Instance like this can represent both final screen and value to provide.
class ExampleDestination<C> {

    let destination: DestinationStep<C>

    let context: C

    init(step: DestinationStep<C>, context: C) {
        self.destination = step
        self.context = context
    }

}
