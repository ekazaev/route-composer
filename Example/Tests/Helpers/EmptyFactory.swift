//
// Created by Eugene Kazaev on 25/07/2018.
//

#if os(iOS)

import Foundation
@testable import RouteComposer
import UIKit

struct EmptyFactory: Factory {

    init() {}

    func build(with context: Any?) throws -> UIViewController {
        return UIViewController()
    }

}

#endif
