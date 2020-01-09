//
// Created by Eugene Kazaev on 16/01/2018.
//

#if os(iOS)

import Foundation
import UIKit

/// - The `UITabBarController` extension is to support the `ContainerViewController` protocol
extension UITabBarController: ContainerViewController {

    public var canBeDismissed: Bool {
        return viewControllers?.canBeDismissed ?? true
    }

}

#endif
