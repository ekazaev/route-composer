//
// Created by Eugene Kazaev on 2018-10-12.
// Copyright (c) 2018 HBC Digital. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer

// Its only purpose is to demo that you can reuse built-in actions with your custom classes
class ExampleNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // It is better to use the appearance protocol for such modifications
        navigationBar.barTintColor = UIColor.lightGray
    }

}
