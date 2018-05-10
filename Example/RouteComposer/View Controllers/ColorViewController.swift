//
// Created by Eugene Kazaev on 19/12/2017.
// Copyright (c) 2017 HBC Tech. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer

class ColorViewControllerFinder: StackIteratingFinder {

    public let options: SearchOptions

    public init(options: SearchOptions = .currentAllStack) {
        self.options = options
    }

    func isTarget(_ viewController: ColorViewController, with context: ExampleDictionaryContext) -> Bool {
        guard let destinationColorHex = context[Argument.color] as? ColorViewController.ColorDisplayModel else {
            return false
        }
        viewController.colorHex = destinationColorHex
        return true
    }

}

class ColorViewControllerFactory: Factory {

    let action: Action

    var model: ColorViewController.ColorDisplayModel?

    init(action: Action) {
        self.action = action
    }

    func prepare(with context: ExampleDictionaryContext) throws {
        guard let model = context[Argument.color] as? ColorViewController.ColorDisplayModel else {
            throw RoutingError.message("Color has not been set in context")
        }

        self.model = model
    }

    func build(with context: ExampleDictionaryContext) throws -> ColorViewController {
        let colorViewController = ColorViewController(nibName: nil, bundle: nil)
        colorViewController.colorHex = model

        return colorViewController
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
