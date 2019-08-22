//
// Created by Eugene Kazaev on 16/01/2018.
//

import Foundation
import UIKit

/// - The `UINavigationController` extension is to support the `ContainerViewController` protocol
extension UINavigationController: ContainerViewController {

    public var canBeDismissed: Bool {
        return viewControllers.canBeDismissed
    }

}
