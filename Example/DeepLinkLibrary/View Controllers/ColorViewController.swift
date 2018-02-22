//
// Created by Eugene Kazaev on 19/12/2017.
// Copyright (c) 2017 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

class ColorViewControllerFinder: FinderWithPolicy {

    typealias V = ColorViewController

    typealias C = ExampleDictionaryContext

    let policy: FinderPolicy

    init(policy: FinderPolicy = .currentLevel) {
        self.policy = policy
    }

    func isTarget(viewController: V, context: C?) -> Bool {
        guard let context = context,
              let destinationColorHex = context[Argument.color] as? ColorViewController.ColorDisplayModel else {
            return false
        }
        viewController.colorHex = destinationColorHex
        return true
    }

}

class ColorViewControllerFactory: Factory {

    typealias V = ColorViewController

    typealias C = ExampleDictionaryContext

    let action: Action

    var context: ColorViewController.ColorDisplayModel?

    init(action: Action) {
        self.action = action
    }

    func build(logger: Logger?) -> V? {
        let colorViewController = ColorViewController(nibName: nil, bundle: nil)
        colorViewController.colorHex = context

        return colorViewController
    }

    func prepare(with context: C?, logger: Logger?) -> RoutingResult {
        guard let context = context,
              let model = context[Argument.color] as? ColorViewController.ColorDisplayModel else {
            return .unhandled
        }

        self.context = model
        return .handled
    }
}

class ColorViewController: UIViewController, AnalyticsSupportViewController {

    let  analyticParameters = ExampleAnalyticsParameters(source: .color)

    typealias ColorDisplayModel = String

    var colorHex: ColorDisplayModel? {
        didSet {
            if let colorHex = colorHex, isViewLoaded {
                self.view.backgroundColor = UIColor(hexString: colorHex)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.accessibilityIdentifier = "colorViewController"
        if let colorHex = colorHex {
            self.view.backgroundColor = UIColor(hexString: colorHex)
        } else {
            self.view.backgroundColor = UIColor.white
        }

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
    }

    @objc func doneTapped() {
        self.dismiss(animated: true)
    }
}
