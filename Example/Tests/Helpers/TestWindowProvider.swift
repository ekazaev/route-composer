//
// RouteComposer
// TestWindowProvider.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2026.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
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
