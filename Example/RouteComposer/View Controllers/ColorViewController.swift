//
// RouteComposer
// ColorViewController.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import RouteComposer
import UIKit

@MainActor class ColorViewControllerFinder: StackIteratingFinder {

    typealias ViewController = ColorViewController

    typealias Context = String

    public let iterator: StackIterator = DefaultStackIterator(options: .currentAllStack,
                                                              windowProvider: RouteComposerDefaults.shared.windowProvider,
                                                              containerAdapterLocator: RouteComposerDefaults.shared.containerAdapterLocator)

    func isTarget(_ viewController: ColorViewController, with colorHex: String) -> Bool {
        viewController.colorHex = colorHex
        return true
    }

}

class ColorViewControllerFactory: Factory {

    typealias ViewController = ColorViewController

    typealias Context = String

    init() {}

    func build(with colorHex: String) throws -> ColorViewController {
        let colorViewController = ColorViewController(nibName: nil, bundle: nil)
        colorViewController.colorHex = colorHex

        return colorViewController
    }

}

class ColorViewController: UIViewController, DismissibleWithRuntimeStorage, ExampleAnalyticsSupport {

    typealias DismissalTargetContext = Void

    let screenType = ExampleScreenTypes.color

    typealias ColorDisplayModel = String

    var colorHex: ColorDisplayModel? {
        didSet {
            if let colorHex, isViewLoaded {
                self.view.backgroundColor = UIColor(hexString: colorHex)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "colorViewController"
        title = "Color"
        if let colorHex {
            view.backgroundColor = UIColor(hexString: colorHex)
        } else {
            view.backgroundColor = UIColor.white
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
    }

    @objc func doneTapped() {
        dismissViewController(animated: true)
    }

}
