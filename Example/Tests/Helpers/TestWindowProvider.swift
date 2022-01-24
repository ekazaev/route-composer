//
// RouteComposer
// TestWindowProvider.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
//

#if os(iOS)

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

#endif
