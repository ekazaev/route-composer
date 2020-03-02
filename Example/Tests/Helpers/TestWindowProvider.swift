//
//  TestWindowProvider.swift
//  RouteComposerTests
//
//  Created by Eugene Kazaev on 01/03/2020.
//  Copyright © 2020 Eugene Kazaev. All rights reserved.
//

import Foundation
@testable import RouteComposer
import UIKit

class TestWindow: UIWindow {
    var isKey: Bool = false

    override func makeKeyAndVisible() {
        isKey = true
    }

}

struct TestWindowProvider: WindowProvider {
    let window: UIWindow?

    init(window: UIWindow) {
        self.window = window
    }
}
