//
// Created by Eugene Kazaev on 2018-11-07.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit
import XCTest
@testable import RouteComposer

class FinderTest: XCTestCase {

    func testInstanceFinder() {
        let viewController = UIViewController()
        let finder = InstanceFinder<UIViewController, Any?>(instance: viewController)
        XCTAssertEqual(finder.instance, viewController)
        XCTAssertEqual(finder.findViewController(with: nil), viewController)
    }

}
