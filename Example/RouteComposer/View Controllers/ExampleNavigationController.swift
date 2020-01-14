//
// Created by Eugene Kazaev on 2018-10-12.
//

import Foundation
import RouteComposer
import UIKit

// Its only purpose is to demo that you can reuse built-in actions with your custom classes
class ExampleNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // It is better to use the appearance protocol for such modifications
        navigationBar.barTintColor = UIColor.lightGray
    }

}
