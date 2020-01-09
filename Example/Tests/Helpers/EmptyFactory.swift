//
// Created by Eugene Kazaev on 25/07/2018.
//

#if os(iOS)

import Foundation
import UIKit
@testable import RouteComposer

struct EmptyFactory: Factory {

    init() {
    }

    func build(with context: Any?) throws -> UIViewController {
        return UIViewController()
    }

}

#endif
