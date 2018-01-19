//
// Created by Eugene Kazaev on 13/01/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit
import DeepLinkLibrary

class RoutingRuleSupportViewController: UIViewController, RouterRulesViewController {

    private(set) var canBeDismissed: Bool = true

    @IBOutlet private var switchControl: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.switchControl.isOn = self.canBeDismissed
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
    }


    @IBAction func switchValueChanged(sender: UISwitch) {
        self.canBeDismissed = switchControl.isOn
    }

    @objc func doneTapped() {
        self.dismiss(animated: true)
        //DefaultRouter().deepLinkTo(destination: configuration.destination(for: ExampleTarget.home)!)
    }

    @IBAction func goToColorTapped() {
        DefaultRouter().deepLinkTo(destination: configuration.destination(for: ExampleTarget.color, arguments: ExampleDictionaryArguments(arguments: [Argument.color: "FFFF00"]))!)
    }

    @IBAction func goToSquareTapped() {
        DefaultRouter().deepLinkTo(destination: configuration.destination(for: ExampleTarget.square)!)
    }

    @IBAction func goToMoscowTapped() {
        DefaultRouter().deepLinkTo(destination: CitiesConfiguration.cityDetail(cityId: 2))
    }
}
