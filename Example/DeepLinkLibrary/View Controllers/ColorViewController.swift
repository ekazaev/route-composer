//
// Created by Eugene Kazaev on 19/12/2017.
// Copyright (c) 2017 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

class ColorViewControllerFinder: FinderWithPolicy {
    public typealias V = ColorViewController
    public typealias A = ExampleDictionaryArguments

    let policy: FinderPolicy

    init(policy: FinderPolicy = .currentLevel) {
        self.policy = policy
    }

    func isTarget(viewController: V, arguments: A?) -> Bool {
        guard let arguments = arguments,
              let destinationColorHex = arguments[Argument.color] as? ColorViewController.ColorDisplayModel else {
            return false
        }
        viewController.colorHex = destinationColorHex
        return true
    }

}

class ColorViewControllerFactory: Factory {

    public typealias V = ColorViewController
    public typealias A = ExampleDictionaryArguments

    let action: Action

    var arguments: ColorViewController.ColorDisplayModel?

    init(action: Action) {
        self.action = action
    }

    func build(with logger: Logger?) -> V? {
        let colorViewController = ColorViewController(nibName: nil, bundle: nil)
        colorViewController.colorHex = arguments

        return colorViewController
    }

    func prepare(with arguments: A?) -> RoutingResult {
        guard let arguments = arguments,
              let model = arguments[Argument.color] as? ColorViewController.ColorDisplayModel else {
            return .unhandled
        }

        self.arguments = model
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
