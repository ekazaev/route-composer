//
// RouteComposer
// ColorViewController.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2026.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
@_spi(Advanced) import RouteComposer
import UIKit

class ColorViewControllerFinder: StackIteratingFinder {

    typealias ViewController = ColorViewController

    typealias Context = String

    let iterator: StackIterator = DefaultStackIterator(options: .currentAllStack,
                                                       windowProvider: RouteComposerDefaults.shared.windowProvider,
                                                       containerAdapterLocator: RouteComposerDefaults.shared.containerAdapterLocator)

    func isTarget(_ viewController: ColorViewController, with colorHex: String) -> Bool {
        viewController.colorHex = colorHex
        return true
    }

}

extension ColorViewControllerFinder {
    /// Shorthand to be used as `.using(.colorViewControllerFinder)`
    static var colorViewControllerFinder: ColorViewControllerFinder { ColorViewControllerFinder() }
}

extension StepAssembler where VC == ColorViewController, C == String { // Add new finder method for shorthand .colorViewControllerFinder
    func finder(_ finder: ColorViewControllerFinder) -> StepAssemblerWithFinder<ColorViewControllerFinder> {
        return getFinder(finder) // Advanced method
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

extension ColorViewControllerFactory {
    /// Shorthand to be used as `.using(.colorViewControllerFactory)`
    static var colorViewControllerFactory: ColorViewControllerFactory { ColorViewControllerFactory() }
}

extension StepAssemblerWithFinder where F.ViewController == ColorViewController, F.Context == String { // Add new factory method for shorthand .colorViewControllerFactory
    func factory(_ factory: ColorViewControllerFactory) -> StepAssembly<F, ColorViewControllerFactory> {
        return getFactory(factory)
    }
}

class ColorViewController: UIViewController, DismissibleWithRuntimeStorage, ExampleAnalyticsSupport {

    typealias DismissalTargetContext = Void

    let screenType = ExampleScreenTypes.color

    typealias ColorDisplayModel = String

    var colorHex: ColorDisplayModel? {
        didSet {
            if let colorHex, isViewLoaded {
                view.backgroundColor = UIColor(hexString: colorHex)
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
