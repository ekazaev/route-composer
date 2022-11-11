//
// RouteComposer
// SettingsViewController.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import RouteComposer
import UIKit

class SettingsViewController: AnyContextCheckingViewController<MainScreenContext> {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        title = "Settings"
        view.accessibilityIdentifier = "settingsViewController"
    }

    override func isTarget(for context: MainScreenContext) -> Bool {
        return context == .settings
    }
}
