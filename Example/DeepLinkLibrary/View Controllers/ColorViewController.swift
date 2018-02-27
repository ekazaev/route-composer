//
// Created by Eugene Kazaev on 19/12/2017.
// Copyright (c) 2017 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

class ColorViewControllerFinder: FinderWithPolicy {

    typealias ViewController = ColorViewController

    typealias Context = ExampleDictionaryContext

    let policy: FinderPolicy

    init(policy: FinderPolicy = .currentLevel) {
        self.policy = policy
    }

    func isTarget(viewController: ViewController, context: Context?) -> Bool {
        guard let context = context,
              let destinationColorHex = context[Argument.color] as? ColorViewController.ColorDisplayModel else {
            return false
        }
        viewController.colorHex = destinationColorHex
        return true
    }

}

class ColorViewControllerFactory: Factory {

    typealias ViewController = ColorViewController

    typealias Context = ExampleDictionaryContext

    let action: Action

    var model: ColorViewController.ColorDisplayModel?

    init(action: Action) {
        self.action = action
    }

    func build(with context: Context?) throws -> UIViewController {
        let colorViewController = ColorViewController(nibName: nil, bundle: nil)
        colorViewController.colorHex = model

        return colorViewController
    }

    func prepare(with context: Context?) throws {
        guard let context = context,
              let model = context[Argument.color] as? ColorViewController.ColorDisplayModel else {
            throw RoutingError.message("Color has not been set in context")
        }

        self.model = model
    }
}

class ColorViewController: UIViewController, ExampleAnalyticsSupport {

    let analyticParameters = ExampleAnalyticsParameters(source: .color)

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
