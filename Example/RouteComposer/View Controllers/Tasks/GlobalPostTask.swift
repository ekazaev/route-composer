//
// Created by Eugene Kazaev on 18/06/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer

class GlobalPostTask: PostRoutingTask {

    func execute(on viewController: UIViewController, for destination: ExampleDestination, routingStack: [UIViewController]) {
        print("Routing finished in \(viewController)")
    }

}
