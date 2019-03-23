//
// Created by Eugene Kazaev on 25/07/2018.
// Copyright (c) 2018 HBC Digital. All rights reserved.
//

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
