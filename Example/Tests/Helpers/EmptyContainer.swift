//
// Created by Eugene Kazaev on 25/07/2018.
//

#if os(iOS)

import Foundation
import UIKit
@testable import RouteComposer

struct EmptyContainer: SimpleContainerFactory {

    typealias ViewController = UINavigationController

    typealias Context = Any?

    init() {
    }

    func build(with context: Any?, integrating viewControllers: [UIViewController]) throws -> UINavigationController {
        let viewController = UINavigationController()
        viewController.viewControllers = viewControllers
        return viewController
    }

}

#endif
