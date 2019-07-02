//
// Created by Eugene Kazaev on 16/01/2018.
// Copyright © 2018 HBC Digital. All rights reserved.
//

import Foundation
import UIKit

// - The `UISplitViewController` extension is to support the `ContainerViewController` protocol
extension UISplitViewController: ContainerViewController {

    public var canBeDismissed: Bool {
        return viewControllers.canBeDismissed
    }

}
